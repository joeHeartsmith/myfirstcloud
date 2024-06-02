set-provider-aws:
	@rm -f ./CONFIG
	@ln -fs ./template/CONFIG_AWS ./CONFIG

set-provider-do:
	@rm -f ./CONFIG
	@ln -fs ./template/CONFIG_DO ./CONFIG

keys:
	@echo -e '[\x1b[32;49;1m  OK  \x1b[39;49m] Generating SSH Keypairs'
	@test -d keys || mkdir ./keys
	@test -s keys/site1-key_external || ssh-keygen -f keys/site1-key_external -N '' >> /dev/null 2>&1
	@test -s keys/site1-key_internal_dns || ssh-keygen -f keys/site1-key_internal_dns -N '' >> /dev/null 2>&1
	@test -s keys/site1-key_internal_web || ssh-keygen -f keys/site1-key_internal_web -N '' >> /dev/null 2>&1
	@test -s keys/site1-key_internal_mail || ssh-keygen -f keys/site1-key_internal_mail -N '' >> /dev/null 2>&1
	@test -s keys/site1-key_internal_client || ssh-keygen -m PEM -f keys/site1-key_internal_client -N '' >> /dev/null 2>&1

destroy-keys:
	@echo -e '[\x1b[32;49;1m  OK  \x1b[39;49m] Deleting SSH Keys'
	@rm -r ./keys

templates:
	@echo -e '[\x1b[32;49;1m  OK  \x1b[39;49m] Generating Template File Outputs'
	@python3 ./template/site.tf.py ./CONFIG ./template/site.tf.jinja ./site.tf
	@python3 ./template/packer.pkr.hcl.py ./CONFIG ./template/packer.pkr.hcl.jinja ./packer.pkr.hcl
	@python3 ./template/playbook.yaml.py ./CONFIG ./template/playbook.yaml.jinja ./playbook.yaml

destroy-templates:
	@echo -e '[\x1b[32;49;1m  OK  \x1b[39;49m] Deleting Template File Outputs'
	@rm ./site.tf ./packer.pkr.hcl ./playbook.yaml

destroy-images:
	@echo -e '[\x1b[32;49;1m  OK  \x1b[39;49m] Destroying Cloud Images'
	@./tools/destroy-amis.sh
	@./tools/destroy-do-images.sh

packer:
	@echo -e '[\x1b[32;49;1m  OK  \x1b[39;49m] Building Packer Images'
	@packer init ./packer.pkr.hcl
	@packer build ./packer.pkr.hcl

terraform: site.tf
	@echo -e '[\x1b[32;49;1m  OK  \x1b[39;49m] Running Terraform'
	@terraform init
	@terraform validate >> /dev/null 2>&1
	@terraform apply -auto-approve


destroy-terraform:
	@echo -e '[\x1b[31;49;1m KILL \x1b[39;49m] Destroying Terraform'
	@terraform destroy -auto-approve



ansible-inventory-reset: inventory.yaml
	@echo 'external_host:' > ./inventory.yaml
	@echo '    hosts:' >> ./inventory.yaml
	@echo '        EXTERNAL_HOST_IP' >> ./inventory.yaml
	@echo 'internal_host_dns:' >> ./inventory.yaml
	@echo '    hosts:' >> ./inventory.yaml
	@echo '        INTERNAL_HOST_DNS_IP' >> ./inventory.yaml
	@echo 'internal_host_web:' >> ./inventory.yaml
	@echo '    hosts:' >> ./inventory.yaml
	@echo '        INTERNAL_HOST_WEB_IP' >> ./inventory.yaml
	@echo 'internal_host_mail:' >> ./inventory.yaml
	@echo '    hosts:' >> ./inventory.yaml
	@echo '        INTERNAL_HOST_MAIL_IP' >> ./inventory.yaml


ansible: ansible-inventory-reset zonefile-reset resolv-reset inventory.yaml playbook.yaml
	@echo -e '[\x1b[32;49;1m  OK  \x1b[39;49m] Running Ansible Playbook'
	@sed -i "s/EXTERNAL_HOST_IP/$$(terraform output -raw site1-ip_public)/" ./inventory.yaml
	@sed -i "s/INTERNAL_HOST_DNS_IP/$$(terraform output -raw site1-ip_public)/" ./inventory.yaml
	@sed -i "s/INTERNAL_HOST_WEB_IP/$$(terraform output -raw site1-ip_public)/" ./inventory.yaml
	@sed -i "s/INTERNAL_HOST_MAIL_IP/$$(terraform output -raw site1-ip_public)/" ./inventory.yaml
	@ANSIBLE_HOST_KEY_CHECKING=False ANSIBLE_TIMEOUT=30 ansible-playbook -i ./inventory.yaml ./playbook.yaml


mail-creds:
	@echo USERNAME=$$(cat ./content/mail/config | grep FIRST_DOMAIN | awk '{print $2;}' | cut -d '=' -f 2 | grep -Eo '[A-Za-z0-9]*\.[A-Za-z0-9]*')
	@grep -o DOMAIN_ADMIN_PASSWD_PLAIN=\'.*\' ./content/mail/config


zonefile-reset:
	@cat ./content/dns/site1-zone.conf.START > ./content/dns/_etc_unbound_unbound.conf.d_site1-zone.conf


resolv-reset:
	@cat ./content/common/resolv.conf.START > ./content/common/resolv.conf


init-pause:
	@echo -e '[\x1b[33;49;1m WAIT \x1b[39;49m] Waiting 1m for Services to Start...'
	@sleep 1m



prep: destroy-templates templates zonefile-reset resolv-reset
all: keys templates zonefile-reset resolv-reset terraform init-pause ansible mail-creds
full: keys templates zonefile-reset resolv-reset packer terraform init-pause ansible mail-creds
destroy-all: ansible-inventory-reset destroy-terraform destroy-keys destroy-templates
	@rm -rf ./.terraform* ./terraform*
destroy-full: ansible-inventory-reset destroy-terraform destroy-keys destroy-templates destroy-images
	@rm -rf ./.terraform* ./terraform*
