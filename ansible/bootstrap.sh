#!/bin/bash

cd /vagrant

git clone http://github.com/ansible/ansible
source ansible/hacking/env-setup
chmod +x ansible/hacking/test-module

ansible/hacking/test-module -m library/bgdeployment.py -a "name=bdd blue_port=9001 green_port=9002 state=retrieved"
ansible/hacking/test-module -m library/bgdeployment.py -a "name=bdd blue_port=9001 green_port=9002 state=changed"

ansible-playbook bdd2.yml