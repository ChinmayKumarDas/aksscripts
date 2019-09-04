#!/bin/bash
echo "Please enter the ResourceGroup name"
read rgname
echo "please enter the cluster name"
read clname
az aks get-credentials -g $rgname -n $clname &>/dev/null
az aks scale -g $myResourceGroup -n $myAKSCluster -c 2
nodecount=`kubectl get nodes | grep aks | wc -l` >/tmp/scen2
if [ $nodecount == 2 ]
then
echo northernjumpaway
else
echo "Scenario 3 result is FAILED"
fi
