#!/usr/bin/python3

import sys
from jinja2 import Environment, FileSystemLoader

CONFIGFILE=sys.argv[1]
with open(CONFIGFILE, mode="r") as configfile:
    config = configfile.readlines()
configfile.close()

PROVIDER=config[0].split("=")[1].strip("\n")
DOMAIN=config[1].split("=")[1].strip("\n")
SITE=DOMAIN.split(".")[0]
TF_REGION=config[2].split("=")[1].strip("\n")
API_KEY_1=config[4].split("=")[1].strip("\n")
API_KEY_2=config[5].split("=")[1].strip("\n")
API_KEY_3=config[6].split("=")[1].strip("\n")
IMAGE_PUBLIC=config[7].split("=")[1].strip("\n")
IMAGE_DNS=config[8].split("=")[1].strip("\n")
IMAGE_WEB=config[9].split("=")[1].strip("\n")
IMAGE_MAIL=config[10].split("=")[1].strip("\n")
IMAGE_CLIENT=config[11].split("=")[1].strip("\n")
INSTANCE_TYPE_PUBLIC=config[12].split("=")[1].strip("\n")
INSTANCE_TYPE_DNS=config[13].split("=")[1].strip("\n")
INSTANCE_TYPE_WEB=config[14].split("=")[1].strip("\n")
INSTANCE_TYPE_MAIL=config[15].split("=")[1].strip("\n")
INSTANCE_TYPE_CLIENT=config[16].split("=")[1].strip("\n")
USERNAME=config[20].split("=")[1].strip("\n")

environment = Environment(loader=FileSystemLoader("./"), trim_blocks = True)
TEMPLATEFILE = sys.argv[2]
template = environment.get_template(TEMPLATEFILE)
content = template.render({"TF_PROVIDER": PROVIDER, "SITE": SITE, "TF_REGION": TF_REGION, "API_KEY_1": API_KEY_1, "API_KEY_2": API_KEY_2, "API_KEY_3": API_KEY_3, "IMAGE_PUBLIC": IMAGE_PUBLIC, "IMAGE_DNS": IMAGE_DNS, "IMAGE_WEB": IMAGE_WEB, "IMAGE_MAIL": IMAGE_MAIL, "IMAGE_CLIENT": IMAGE_CLIENT, "INSTANCE_TYPE_PUBLIC": INSTANCE_TYPE_PUBLIC, "INSTANCE_TYPE_DNS": INSTANCE_TYPE_DNS, "INSTANCE_TYPE_WEB": INSTANCE_TYPE_WEB, "INSTANCE_TYPE_MAIL": INSTANCE_TYPE_MAIL, "INSTANCE_TYPE_CLIENT": INSTANCE_TYPE_CLIENT, "USERNAME": USERNAME})

OUTFILE=sys.argv[3]
with open(OUTFILE, mode="w") as outfile:
    outfile.write(content)
    outfile.write('\n')
outfile.close()
