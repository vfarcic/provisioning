#!/bin/bash

# Common
sudo apt-get install -y whois

# Ansible
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible

# ssh-keygen -t rsa
# ssh-copy-id vagrant@localhost

# Playing around
ansible local -m ping
ansible local -a '/bin/echo hello'
ansible local -m file -a 'dest=/tmp/ansible mode=755 owner=vagrant group=vagrant state=directory'
ansible local -m apt -a 'name=openjdk-7-jre state=present' --sudo

## User
mkpasswd --method=SHA-512 welcome
ansible local -m user -a 'name=jdoe password=$6$9w0Q2OFs0Jr0iz7m$uSLEZB.ViajuQudDWYVf5IPBibgbGZtPyWE/OC1TPIGYmuysgoyDWKiXdSPw9LBN5jUrYTMR0R5Azt/BPiYsW0' --sudo

## Service
ansible local -m apt -a 'name=nginx state=present' --sudo
ansible local -m service -a "name=nginx state=started" --sudo
ansible local -m service -a "name=nginx state=restarted" --sudo
ansible local -m service -a "name=nginx state=stopped" --sudo

## Facts
ansible local -m setup

## Single playbook
cd /vagrant/
ansible-playbook services.yml

## Include playbook
ansible-playbook include.yml

## Roles
ansible-playbook roles.yml