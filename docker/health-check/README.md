```
docker run -v /var/run/docker.sock:/var/run/docker.sock \
  -t -d --privileged --name --sitrep-socket \
  --entrypoint=/bin/sh byrnedo/alpine-curl

docker exec -it sitrep-socket \
  curl -XGET --unix-socket /var/run/docker.sock \
  http://localhost/containers/json
