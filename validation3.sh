#!/bin/bash
echo "Please enter the ResourceGroup name"
read myResourceGroup
echo "please enter the cluster name"
read myAKSCluster
az aks get-credentials -g $myResourceGroup -n $myAKSCluster &>/dev/null
az aks scale -g $myResourceGroup -n $myAKSCluster -c 2
kubectl get nodes | grep "NotReady" >/dev/null
if [ $? == 0 ]
then
echo "Scenario 3 result is FAILED"
else
echo northernjumpaway
fi
