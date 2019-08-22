!/bin/bash
(kubectl get nodes | grep "NotReady") >/dev/null
if [ $? -eq 0 ]
then
echo "Scenario 1 is FAILED"
else
echo "hometradebroke"
fi
