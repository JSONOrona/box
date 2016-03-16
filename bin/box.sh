#!/bin/bash
#set -x
#EDITOR=vi

config='/srv/uw-projects/box/configuration/default.conf'

source ${config}

if [ ${provisioner} == 'ec2' ]; then
  kitchen_yml='../templates/kitchen.ec2.yml'
  [ -n "${ssh_key_id}" ] || (echo "[Error] Please specify 'ssh_key_id'" ; exit 127)
  [ -n "${region}" ] || (echo "[Error] Please specify 'region'" ; exit 127)
  [ -n "${image_id}" ] || (echo "[Error] Please specify 'image_id'" ; exit 127)
  [ -n "${instance_type}" ] || (echo "[Error] Please specify 'instance_type'" ; exit 127)
elif [ ${provisioner} == 'vagrant' ]; then
  kitchen_yml='..templates/kitchen.vagrant.yml'
else
  echo "[ERROR] - Unknown provisioner: ${provisioner}. Use 'ec2' or 'vagrant'"
  exit 127
fi

check_params(){
  echo "Validate Configuration File";
}

make-env(){
  mkdir -p ${base_dir}
  cd ${base_dir}
  chef generate cookbook ${cookbook_name} --berks
}

edit-config(){
  $EDITOR ${config} 2>/dev/null || echo "Please set the environment variable:\
  export EDITOR=vim
  "
}

workon(){
  echo "Changing directory to ${base_dir}/${cookbook_name}"
  cd ${base_dir}/${cookbook_name}
  echo "Directory contents:"
  ls -ltr
}

show(){
  echo "Currently provisioned boxes:"
  echo ""
  cd ${base_dir}/${cookbook_name}
  kitchen list
  exit 0
}

destroy(){
  echo "Destroying ${hostname} box:";
  cd ${base_dir}/${cookbook_name}
  kitchen destroy
}

create(){
  echo "Creating new machine...";
  make-env
  cd ${base_dir}/${cookbook_name}
  echo "Machine details:";
  kitchen create
}

provision(){
  echo "Provisioning the box";
  cd ${base_dir}/${cookbook_name}
  kitchen converge
}

show-config(){
  echo "Showing config..."
  cat ${config}
}

help(){
  echo ""
  echo "Available Commands: "
  echo ""
  echo "box create         # creates a vm based on config.sh"
  echo "box provision      # creates and provisions a vm"
  echo "box destroy        # destroys a vm"
  echo "box workon         # changes to the vm's working directory"
  echo "box show-config    # shows running configuration"
  echo "box edit-config    # edit configuration "
  echo ""
}

ssh(){
  echo "Logging into box"
  cd ${base_dir}/${cookbook_name}
  kitchen login
}

box(){
  func=${1}
  $func
}

box ${1}
