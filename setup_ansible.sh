#!/bin/bash

## Enable EPEL repository and install Ansible
##  to be run as root, ONCE

yum install -y epel-release
yum install -y ansible

## Prevent error: "ERROR: problem running ansible_hosts --list ([Errno 8] Exec format error)"
##  see: http://stackoverflow.com/questions/18385925/error-when-running-ansible-playbook
##  see: https://groups.google.com/forum/#!topic/ansible-project/l3MRIiSDwIc
mv /etc/ansible/hosts /etc/ansible/hosts.example
cp hosts /etc/ansible/hosts
chmod -x /etc/ansible/hosts
