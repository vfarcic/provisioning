# etcd

remote_file '/opt/etcd-v2.0.0-rc.1-linux-amd64.tar.gz' do
  source 'https://github.com/coreos/etcd/releases/download/v2.0.0-rc.1/etcd-v2.0.0-rc.1-linux-amd64.tar.gz'
end

execute 'install etcd' do
  command 'cd /opt/ && tar -xzf etcd-v2.0.0-rc.1-linux-amd64.tar.gz'
  creates '/opt/etcd-v2.0.0-rc.1-linux-amd64'
end

link '/usr/local/bin/etcd' do
  to '/opt/etcd-v2.0.0-rc.1-linux-amd64/etcd'
end

link '/usr/local/bin/etcdctl' do
  to '/opt/etcd-v2.0.0-rc.1-linux-amd64/etcdctl'
end

#- name: etcd service files is present
#  copy:
#    src=etcd.conf
#    dest=/etc/init/etcd.conf
#  tags: [etcd]
#- name: etcd service is started
#  service:
#    name=etcd
#    pattern=/usr/local/bin/etcd
#    state=started
#  tags: [etcd]

# confd

directory '/etc/confd/conf.d/' do
  recursive true
end

directory '/etc/confd/templates/' do
  recursive true
end

#- name: confd is uncompressed
#  copy:
#    src=confd-0.6.3-linux-amd64
#    dest=/opt/confd-0.6.3-linux-amd64
#    mode="0755"
#  tags: [confd]
#- name: confd has the soft link
#  file:
#    src=/opt/confd-0.6.3-linux-amd64
#    dest=/usr/local/bin/confd
#    state=link
#  tags: [confd]
#- name: confd/confd.d directory is present
#  file:
#    path=/etc/confd/conf.d
#    state=directory
#- name: confd/templates directory is present
#  file:
#    path=/etc/confd/templates
#    state=directory

# Docker

package 'docker.io'

# nginx

#- name: sites-enabled directory is present
#  file:
#    path=/etc/nginx/sites-enabled
#    state=directory
#  tags: [nginx]
#- name: certs-enabled directory is present
#  file:
#    path=/etc/nginx/certs-enabled
#    state=directory
#  tags: [nginx]
#- name: log directory is present
#  file:
#    path=/var/log/nginx
#    state=directory
#  tags: [nginx]
#- name: nginx container is running
#  docker:
#    image: "dockerfile/nginx"
#    name: "nginx"
#    state: "running"
#    ports: "80:80"
#    volumes: "{{ volumes }}"
#  tags: [nginx]

# BDD

template '/etc/confd/conf.d/bdd.toml' do
  source 'bdd.toml.erb'
end

#- name: Config template is present
#  copy:
#    src=bdd.conf.tmpl
#    dest=/etc/confd/templates/bdd.conf.tmpl
#  tags: [bdd]
#- name: Deployment script is present
#  copy:
#    src=deploy-bdd.sh
#    dest=/usr/local/bin/deploy-bdd.sh
#    mode="0755"
#  tags: [bdd]
#- name: Deployment is run
#  shell: deploy-bdd.sh
#  tags: [bdd]