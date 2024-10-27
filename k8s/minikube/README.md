

Dashboard
=========
> minikube dashboard

Start | Stop | Status
=====================
minkube start
minikube stop
minikube status

Launching
=========
> kubectl apply -f .

Pod Status
===========
> kubectl get all

Log into a container
====================
* Make sure the container/pod is running using the "kubectl get all"
kubectl exec -it secureOrderer-orderer-0 sh
kubectl exec -it secureOrderer-peer-0 sh
kubectl exec -it secOrg-peer-0 sh

==================
1. Launch the Pods
==================
* Video shows the launch of pods one by one, here we are launching all at the same time
> cd minikube
> kubectl apply -f .

==================
2. secureOrderer Peer Setup
==================
Log into the secureOrderer peer:
> kubectl exec -it secureOrderer-peer-0 sh

Setup the peer:
> ./submit-channel-create.sh
> ./join-channel.sh


Validate the peer:
> ./cc-test.sh install
> ./cc-test.sh instantiate
> ./cc-test.sh invoke  
> ./cc-test.sh query
> exit

====================
3. secOrg Peer Setup
====================
Log into the secOrg peer:
kubectl exec -it secOrg-peer-0 sh

Setup the peer:
> ./fetch-channel-block.sh
> ./join-channel.sh

Validate the peer:
./cc-test.sh install
./cc-test.sh query      # This should show the same value for a on both peers