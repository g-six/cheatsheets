#!/bin/bash
docker run -v /var/run/docker.sock:/var/run/docker.sock \
  -t -d --privileged --name sitrep-socket \
  --entrypoint=/bin/sh byrnedo/alpine-curl
