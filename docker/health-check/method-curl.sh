#!/bin/bash
if [[ $# -ne 2 ]] ; then
  echo 'Error'
  exit  1
fi
cd /home/gerard/cheatsheets/docker/health-check
node './method-curl.js' $1 "$2"
