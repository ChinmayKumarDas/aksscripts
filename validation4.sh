echo "Please enter the ResourceGroup name"
read rgname
echo "please enter the cluster name"
read clname
az aks get-credentials -g $rgname -n $clname &>/dev/null

kubectl get clusterrolebinding -n kube-system | grep -i dashboard &>/dev/null
if [ $? -eq 0 ]
then
echo -e "\nYou can able to access the $clname cluster dashboard\n"
echo bestkitchenplains
else
echo -e "\nStill the dashboard issue persists\n"
fi
