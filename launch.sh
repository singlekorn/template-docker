#!/bin/bash

doit() {
 docker build -t "${1}":"${2}" . && docker run --rm --env-file .env -it --gpus=all "${1}":"${2}"
}

function usage {
        echo -e "\e[1;36mOptions for $(basename $0)\e[0m:"
        echo " -t <tag>     [REQUIRED] sets image tag" 
        echo " -h           shows this message"
}

if [ ${#} -eq 0 ]; then
    echo -e "\e[1;31mError\e[0m: This script has reqired arguments.  Use -h for help" >&2
    usage
    exit 2
fi

optstring="t:hppurge"

while getopts ${optstring} arg; do
  case ${arg} in
    (h)
      echo "Showing usage:"
      usage
      exit 1
      ;;
    (t)
      echo -e "Using tag: \e[31m${OPTARG}\e[0m"
      TAG="${OPTARG}"
      ;;
    (p|purge)
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
    (:)
      echo -e "\e[1;31mError\e[0m: -${OPTARG} requires an argument." >&2
      exit 2
      ;;
    (?)
      echo -e "\e[1;31mError\e[0m Invalid option: -${OPTARG}." >&2
      exit 2
      ;;
  esac
done

IMAGE=$(pwd | awk -F'/' '{print $NF}')

echo -e "\e[1;36m= Launching\e[0m \e[32m${IMAGE}\e[0m:\e[31m${TAG}\e[0m Building, Running, & Removing..."
doit ${IMAGE} ${TAG}
