#!/bin/bash
echo "Please enter the ResourceGroup name"
read rgname
echo "please enter the cluster name"
read clname
az aks get-credentials -g $rgname -n $clname &>/dev/null
kubectl get nodes | grep "NotReady" >/dev/null
if [ $? -eq 0 ]
then
echo "Scenario 5 is FAILED"
else
echo "amountdevicerose"
fi
