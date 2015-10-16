# WebArchiving on RHEL / CentOS

Ansible scripts to provision a dev environment suitable for web archiving tools

- OpenWayback
  - OpenJDK 7
  - Tomcat


## Pre-requisites

- Red Hat Enterprise Linux (RHEL) 6.4+ or a derivative (ex: CentOS 6.4)


### Ansible

To install ansible, in the current directory on the RHEL server, execute

    sudo setup_ansible.sh


## Usage

    ansible-playbook playbook-lamp.yml --connection=local


## Proxy

If you are behind a proxy, you can execute the script
`sh setup_proxy.sh` as root to setup the proxy for yum and basic usage.

If you create a user, the lines about proxy should be copied from `/root/.bashrc`
to your own `~/.bashrc`

Proxy with SSH require corkscrew http://www.agroman.net/corkscrew/

Example config:

    #file: ~/.ssh/config
    Host *
    ProxyCommand /usr/bin/corkscrew stcweb.statcan.gc.ca 80 %h %p ~/.ssh/corkscrew-auth

    #file: ~/.ssh/corkscrew-auth  (chmod 600)
    myusername:passwd

Git (uses `http_proxy` var set in `~/.bashrc`)

    git config --global http.proxy $http_proxy


## VirtualBox

If using a cloned image in Oracle VirtualBox, you need to re-initialise the network card:

    rm -f /etc/udev/rules.d/70-persistent-net.rules
    # and edit /etc/sysconfig/network-scripts/ifcfg-eth0 to set ONBOOT=yes
    ifup eth0

After a reboot validate the these two files have the same `eth` name (ie: eth0) and they have the same MAC Address


## Ansible Propaganda

> If you haven’t heard of them before, Ansible and Salt are frameworks that let
  you automate various system tasks. The biggest advantage that they have
  relative to other solutions like Chef and Puppet is that they are capable of
  handling not only the initial setup and provisioning of a server, but also
  application deployment, and command execution. This means you don’t need to
  augment them with other tools like Capistrano, Fabric or Func.

> A huge advantage of using a Configuration Management tool is that they are
  “idempotent”. Idempotency basically means that you can run the directives over
  and over again safely. This has the advantage of letting you monitor, update,
  and correct a server’s configuration regularly over the life of the server.

Official Ansible Doc http://docs.ansible.com/

Into to Ansible https://lextoumbourou.com/blog/posts/getting-started-with-ansible/

Intro/tutorial: http://www.stavros.io/posts/example-provisioning-and-deployment-ansible/
