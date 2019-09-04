#!/bin/bash
echo "Please enter the ResourceGroup name"
read rgname
echo "please enter the cluster name"
read clname
az aks get-credentials -g $rgname -n $clname &>/dev/null

nodecount=`kubectl get nodes | grep aks | wc -l` >/tmp/scen2
if [ $nodecount == 1 ]
then
echo stopeffortsweet
else
echo "Scenario 2 result is FAILED"
fi
