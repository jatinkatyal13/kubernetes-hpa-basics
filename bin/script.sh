#! /bin/bash

###### Arguments ######
DEPLOYMENT_NAME=$1
NUM_OF_PODS=$2


###### Functions ######
errorExit() {
  echo -e "\nError: $1\n"
  exit 1
}

main() {
  if [ -z $NUM_OF_PODS ] || [ -z $DEPLOYMENT_NAME ]; then
    errorExit "Please specify deployment name and number of pods to replicate"
  fi

  kubectl scale deploy $DEPLOYMENT_NAME --replicas=$NUM_OF_PODS
}

main
