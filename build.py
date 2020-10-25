#!/usr/bin/env python3

import os
import sys
import click

# generate kickstart file from jinja2 template

os.chdir(sys.argv[-1])
os.system("packer build -var-file=variables.json ../template.json")
