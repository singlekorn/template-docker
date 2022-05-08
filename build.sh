#!/bin/bash

doit() {
 docker build -t template-docker:"${@}" . && docker run --rm --env-file .env -it template-docker:"${@}"
}

TAG=$(pwd | awk -F'/' '{print $NF}')
echo -e "\e[1;36m============== Building:\e[0m \e[32mtemplate-docker\e[0m:\e[31m${TAG}\e[0m Image and Running..."
doit ${TAG}