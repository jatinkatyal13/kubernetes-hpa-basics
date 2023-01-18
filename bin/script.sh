#! /bin/bash

###### Arguments ######
DEPLOYMENT_NAME=$1
NUM_OF_PODS=$2


###### Functions ######
errorExit() {
  echo -e "\nError: $1\n"
  exit 1
}

patchHpa() {
  replicaDiff=$1
  minReplicas=$NUM_OF_PODS
  maxReplicas=$(($NUM_OF_PODS + $replicaDiff))

  read -r -d '' spec <<EOF
  {
    "spec": {
      "minReplicas": $minReplicas,
      "maxReplicas": $maxReplicas
    }
  }
EOF

  kubectl patch hpa $hpa -p "$spec"
}

main() {
  local hpa
  local minReplicas
  local maxReplicas

  if [ -z $NUM_OF_PODS ] || [ -z $DEPLOYMENT_NAME ]; then
    errorExit "Please specify deployment name and number of pods to replicate"
  fi

  read -r hpa minReplicas maxReplicas <<< $(kubectl get hpa -o=jsonpath="{.items[?(@.spec.scaleTargetRef.name=='$DEPLOYMENT_NAME')]['metadata.name', 'spec.minReplicas', 'spec.maxReplicas']}")

  patchHpa $(($maxReplicas - $minReplicas))
}

main
