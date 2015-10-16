#!/bin/bash

# Proxy config
#  to be run as root, ONCE


## EDIT THIS! User Configuration !EDIT THIS

http_proxy_url="10.254.1.16:80" # NO http://
proxy_username=awesomeuser
proxy_password=s3cr3t

## STOP EDITING ##


## Setup Proxy

echo "proxy=http://${http_proxy_url}"  >> /etc/yum.conf
echo "proxy_username=${proxy_username}" >> /etc/yum.conf
echo "proxy_password=${proxy_password}" >> /etc/yum.conf

echo "http_proxy=\"http://${proxy_username}:${proxy_password}@${http_proxy_url}\""  >> /root/.bashrc
echo "https_proxy=\"http://${proxy_username}:${proxy_password}@${http_proxy_url}\""  >> /root/.bashrc
echo "no_proxy=localhost,127.0.0.1"  >> /root/.bashrc
echo "export http_proxy https_proxy no_proxy" >> /root/.bashrc
