#!/bin/bash
echo "Please enter the ResourceGroup name"
read rgname
echo "please enter the cluster name"
read clname
az aks get-credentials -g $rgname -n $clname &>/dev/null

nodecount=`kubectl get nodes | grep aks | wc -l` >/tmp/scen2
if [ $nodecount == 5 ]
then
echo stopeffortsweet
else
echo "Scenario 2 result is FAILED"
fi
[azuser@ansiblemanage-0 aksscripts]$ cat validation1.sh
!/bin/bash
(kubectl get nodes | grep "NotReady") >/dev/null
if [ $? -eq 0 ]
then
echo "Scenario 1 is FAILED"
else
echo "hometradebroke"
fi

