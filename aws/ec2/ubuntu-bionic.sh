#!/bin/bash
apt-get -y update
apt-get -y upgrade
apt-get -y install apt-transport-https ca-certificates curl software-properties-common python3-pip
apt-get -y update
apt-get -y install nginx
pip3 install awscli --upgrade --user