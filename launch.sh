#!/bin/bash

build() {
 docker build -t "${1}":"${2}" . && docker run --rm --env-file .env -it --gpus=all "${1}":"${2}"
}

# Use the current directory as the docker image name 
IMAGE=$(pwd | awk -F'/' '{print $NF}')

# Script Usage Message
usage() {
        echo -e "\e[1;36mOptions for $(basename $0)\e[0m:"
        echo    " -b <tag>     builds and sets image tag" 
        echo    " -h           shows this message"
        echo    " -p           removes all exited containers, dangling volumes, and dangling images"
        echo -e " -c           removes all image repositories named \e[1;37m${IMAGE}\e[0m"
}

# Script has required parameters but no parameters were found
if [ ${#} -eq 0 ]; then
    echo -e "\e[1;31mError\e[0m: This script has reqired arguments.  Use -h for help" >&2
    usage
    exit 2
fi

# Collect only valid parameters
optstring="b:hpc"
while getopts ${optstring} arg; do
  case ${arg} in
    (h) # Help
      echo "Showing usage:"
      usage
      exit 1
      ;;
    (b) # Build and set the image tag
      TAG="${OPTARG}"
      
      # Execute the docker build & run function
      echo -e "\e[1;36m= Launching\e[0m \e[32m${IMAGE}\e[0m:\e[31m${TAG}\e[0m Building, Running, & Removing..."
      build ${IMAGE} ${TAG}
      ;;
    (p) # Perform some disk space cleanup of unused components
      echo -e "\e[1;36m= Purging all exited containers, dangling volumes, and dangling images\e[0m"
      if [ ! -z $(docker ps -a -q -f status=exited) ]; then
        docker rm $(docker ps -a -q -f status=exited)
      else
        echo ".. no exited containers to purge"
      fi
      if [ ! -z $(docker volume ls -q -f dangling=true) ]; then
        docker volume rm $(docker volume ls -q -f dangling=true)
      else
        echo ".. no dangling volumes to purge"
      fi
      if [ ! -z $(docker images -q -f dangling=true) ]; then
        docker rmi $(docker images -q -f dangling=true)
      else
        echo ".. no dangling images to purge"
      fi
      ;;
    (c) # Remove all images for this Working Direcotry
      echo -e "\e[1;36m= Purging dupliate images\e[0m"
      if [ ! -z "$(docker image ls -q -f=reference=${IMAGE})" ]; then
        docker rmi -f $(docker image ls -q -f=reference=${IMAGE})
      else
        echo ".. no duplicate ${IMAGE} to purge"
      fi
      ;;
    (:) # If required paramter is missing
      echo -e "\e[1;31mError\e[0m: -${OPTARG} requires an argument." >&2
      exit 2
      ;;
    (?) # If invalid paramter is provided
      echo -e "\e[1;31mError\e[0m Invalid option: -${OPTARG}." >&2
      exit 2
      ;;
  esac
done


