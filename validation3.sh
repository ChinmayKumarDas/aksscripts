#!/bin/bash
nodecount=`kubectl get nodes | grep aks | wc -l` >/tmp/scen2
if [ $nodecount == 2 ]
then
echo northernjumpaway
else
echo "Scenario 2 result is FAILED"
fi
