#!/bin/bash

log=`dirname $0`'/ping.log'

status=$(curl -s -o /dev/null -w "%{http_code}" $1)

echo $status > $log

