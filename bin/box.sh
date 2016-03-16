#!/bin/bash
#set -x
#EDITOR=vi

config='/srv/uw-projects/box/configuration/default.conf'

source ../configuration/default.conf

check_params(){
  echo "Validate Configuration File";
}

make-env(){
  mkdir -p ${base_dir}
  cd ${base_dir}
  chef generate cookbook ${cookbook_name} --berks
}

edit(){
  $EDITOR ${config} || echo "Please set the environment variable:\
  export EDITOR=vim
  "
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
  echo "box show           # shows currently running box"
  echo "box create         # creates a box based on config.sh"
  echo "box destroy        # destroys a box"
  echo "box show-config    # Shows running config"
  echo ""
}

ssh(){
  echo "Logging into box"
  cd ${base_dir}/${cookbook_name}
  kitchen login
}

execute-main(){
  func=${1}
  $func
}

execute-main ${1}
