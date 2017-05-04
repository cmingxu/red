#!/bin/bash

docker build -t red .
docker rm -f rails-red 2&> /dev/null
docker run --name rails-red -p 0.0.0.0:3000:3000 -v  /var/run/docker.sock:/var/run/docker.sock -d red


