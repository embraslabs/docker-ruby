#!/bin/bash

docker build -t $IMAGE_NAME --build-arg _RUBY_VERSION=$DOCKER_TAG .