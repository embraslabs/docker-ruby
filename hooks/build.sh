#!/bin/bash

echo ">>>>>>>>> DOCKER_TAG=${DOCKER_TAG}"
echo ">>>>>>>>> SOURCE_BRANCH=${SOURCE_BRANCH}"

docker build -t $IMAGE_NAME --build-arg _RUBY_VERSION=$DOCKER_TAG .