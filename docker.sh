#!/bin/bash

imagename=bu-nginx-proxy/newrelic
forkedimage=reiz/nginx_proxy
container=newrelic-proxy
port=8900

build() {
  clean
  docker build -t imagename .
}

run() {
  if [ "$1" == "clean" ] ; then
    clean
  fi

  # If a local image has not been built, use the dockerhub repo for image of the git repo we forked from.
  [ -z "$(docker images -a -q $imagename)" ] && imagename=$forkedimage

  docker run \
    -d \
    -p ${port}:${port} \
    --name $container \
    -v $(pwd)/nginx_whitelist.conf:/usr/local/nginx/conf/nginx.conf \
    -v $(pwd)/log:/var/log \
    $imagename
}

clean() {
   docker rm -f $container 2> /dev/null
}

case $1 in
  build) build ;;
  run) run "clean" ;;
  all) build && run ;;
esac
