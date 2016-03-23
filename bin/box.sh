#!/bin/bash
#set -x
#EDITOR=vi

base_dir="${HOME}/box"
cookbook_name="development-cookbook"
config='../configuration/default.conf'
repo='https://github.com/redja/development-cookbook.git'

source ${config}

if [ ${provisioner} == 'ec2' ]; then
  kitchen_yml='../templates/kitchen.ec2.yml'
elif [ ${provisioner} == 'vagrant' ]; then
  kitchen_yml='..templates/kitchen.vagrant.yml'
else
  echo "[ERROR] - Unknown provisioner: ${provisioner}. Use 'ec2' or 'vagrant'"
  exit 127
fi

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
  git clone ${repo} 2>/dev/null || echo "Skipped git clone"
  eval "cat <<EOF
  $(<${kitchen_yml})
  EOF" > ${cookbook_name}/.kitchen.yml
  echo "Machine details:";
  cd ${base_dir}/${cookbook_name}/
  kitchen create
}

provision(){
  echo "Provisioning the box";
  cd ${base_dir}/${cookbook_name}
  create
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
  echo "box ssh"
  echo "box provision      # creates and provisions a vm"
  echo "box show-config    # shows running configuration"
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
