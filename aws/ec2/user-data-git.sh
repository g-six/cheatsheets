#!/bin/bash
apt -y update
apt -y upgrade
add-apt-repository ppa:git-core/ppa -y
apt-get -y update
apt-get install git -y
reboot
