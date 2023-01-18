# Question

- Service deployed on kubernetes
- it is on 10 pods
- 1 pod -> 2CPU, 1.5GB
- Node -> 16Core, n2dstandard16 config
- My HPA is at min 10 and max 15
- CPU util for HPA is 60%

> Create a script, 
input -> number of pods

> Research on how to reach to that number

# Solution

## Setup

- Setup starts with setting up basic kubernetes cluster using Docker Desktop.
- We first create a flask application which just serves the hello world endpoint. To build the docker image for the application run the following command
```
docker build ./flask-api -t flask-api
```
- The manifest to deploy our flask application on kubernetes is at `./manifests/flask-api.yml`. It contains the following resources
    - Deployment
    - Load Balancer Service
    - HorizontalPodAutoscaler with `minReplicas` as 1 and `maxReplicas` as 10. Average utilization of CPU is kept at 10% for testing purpose.
- To apply the manifest, run the following command
```
kubectl apply -f ./manifests/flask-api.yml
```

## Script
- As per the requirements to scale the number of pods, we can simply run the following command
```
kubectl scale deploy flaskapi-deployment --replicas=<number of replicas>
```
- The problem with just updating the replicas is that it interferes with HPA.
- The script takes deployment name and number of pods as argument and updates the HPA accordingly
- Currently the script maintains the difference between `minReplicas` and `maxReplicas` after like so
```
minReplicas=$NUM_OF_PODS
maxReplicas=$(($NUM_OF_PODS + $replicaDiff))
```
- Script can be executed in a following manner
```
./bin/script.sh flaskapi-deployment 10
```
