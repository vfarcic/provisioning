#!/bin/bash

wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.3.5-1_amd64.deb
dpkg -i chefdk_0.3.5-1_amd64.deb
rm chefdk_0.3.5-1_amd64.deb
mkdir /var/chef/cookbooks
knife cookbook site download ark
knife cookbook site install ark

cd /vagrant/cookbooks
sudo chef-client --local-mode --runlist 'recipe[bdd]'