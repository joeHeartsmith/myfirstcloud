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
USERNAME=config[20].split("=")[1].strip("\n")
PARADIGM=config[21].split("=")[1].strip("\n")

environment = Environment(loader=FileSystemLoader("./"), trim_blocks = True)
TEMPLATEFILE = sys.argv[2]
template = environment.get_template(TEMPLATEFILE)
content = template.render({"PROVIDER": PROVIDER, "DOMAIN": DOMAIN, "SITE": SITE, "USERNAME": USERNAME, "PARADIGM": PARADIGM})

OUTFILE=sys.argv[3]
with open(OUTFILE, mode="w") as outfile:
    outfile.write(content)
    outfile.write('\n')
outfile.close()
