#!/bin/bash
echo "Please enter the ResourceGroup name"
read rgname
echo "please enter the cluster name"
read clname
az aks get-credentials -g $rgname -n $clname &>/dev/null
az aks scale -g $myResourceGroup -n $myAKSCluster -c 2
kubectl get nodes | grep "NotReady" >/dev/null
if [ $? == 0 ]
then
echo "Scenario 3 result is FAILED"
else
echo northernjumpaway
fi
