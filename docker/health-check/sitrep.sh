#!/bin/bash

docker exec -it sitrep-socket \
  curl -XGET --unix-socket /var/run/docker.sock \
  http://localhost/containers/json | json_pp > sitrep.json
