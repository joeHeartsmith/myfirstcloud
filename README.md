# myfirstcloud
Deploy a Cloud-Based Web Presense FAST!

<img src="mfc.png" width="25%" height="25%">

This is a simple IaC Project to quickly spin up some IaaS infrastructure to do....whatever.  It's templated with Jinja, built with Terraform/OpenTofu, configured with Ansible, and run with GNU Make.
With one stroke of the shell, you're off!

*disclaimer: this project has nothing to do with the Microsoft Foundational Class library. ...but it *does* make setting up an initial project *just* as easy™

TODO: add more providers

--To begin, run the 'start' script, with the desired provider, and site name (no FQDN).  For example:
      `./start aws site1'
  will generate a makefile to create infrastructure in AWS with a site name of 'site1'.
  Make sure that your content is prepended with the corresponsing site name in the 'content/' folder.

-- Currently supported providers are AWS ("aws") and DigitalOcean ("do").

--Make sure API keys are set in the corresponding ./CONFIG_TF


--To build the site, run:
      `make full'
  The default site should build in approximately 10 minutes.


--If the desired instance images have already been generated, run:
      `make all'
  To skip generating new images.  Build time will be substantially faster.


--To destroy the site, run:
      `make destroy-all'
