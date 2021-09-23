"""Install code on Binder.

This script is executed from Dockerfile configuration file
It installs software dependencies declared in environment.yml
in the docker container built for the Binder service.
"""
import yaml
import subprocess
import sys

with open("environment.yml") as stream:
    content = yaml.safe_load(stream)

for chan in content['dependencies']:
    print("RUN pip install {}".format(chan))
    subprocess.call([sys.executable, "-m", "pip", "install", str(chan))
