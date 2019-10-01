#!/bin/bash
sudo apt-get -y install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.7
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
which pip3

echo 'Installing awscli'
pip3 install awscli --upgrade --user

echo 'Done!'
