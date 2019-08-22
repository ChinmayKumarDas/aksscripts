#!/bin/bash
nodecount=`kubectl get nodes | grep aks | wc -l` >/tmp/scen2
if [ $nodecount == 5 ]
then
echo stopeffortsweet
else
echo "Scenario 2 result is FAILED"
fi
