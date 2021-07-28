#!/bin/bash

echo ">>>>>>>>> Criando imagem para rails utilizar o rails como fullstack"
docker build -t embraslabs/ruby:2.7.2-fullstack --build-arg _RUBY_VERSION=2.7.2 --build-arg _IMAGE_TYPE=fullstack .
