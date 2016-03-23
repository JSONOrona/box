#!/bin/bash

export EDITOR=vim
export

sudo pip install awscli

yum update;
yum groupinstall "Development tools";
yum install libvirt-devel libxslt-devel libxml2-devel libvirt-devel libguestfs-tools-c ruby-devel;
curl omnitruck.chef.io/install.sh | sudo bash -s -- -c current -P chefdk per github.com/chef/chef-dk;
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile;
wget --no-check-certificate https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.rpm;
rpm -i vagrant_1.8.1_x86_64.rpm;
vagrant plugin install vagrant-libvirt
export VAGRANT_DEFAULT_PROVIDER=libvirt
service libvirtd restart
vagrant plugin install fog-libvirt --plugin-version 0.0.3
#vagrant up --provider=libvirt
#chef generate cookbook test-cookbook --berks;
