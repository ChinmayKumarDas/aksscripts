#!/bin/bash
#This is a script to create the Troubleshooting environment for the new joinee and help them to know more about L200
echo -e '\t \t Welcome to the L200 Troubleshooting sessions'
echo -e '\t \t ********************************************'
echo -e "***Please sit tight while we create a cluster for you. It is absolute pleasure to assist you***\n \n \n"
echo -e "\nPlease ensure you login to your respective azure account using az login after each scenario got completed\n"
echo -e "NOTE: Each scenario requires a new cluster to be created\n"
echo -e "Please provide the Resource Group Name required to create the AKS Cluster for troubleshooting\n"
read myResourceGroup
az group create --name $myResourceGroup --location eastus &>/dev/null
if [ $? -eq 0 ]
        then
          echo -e "$myResourceGroup Resource Group created succesfully\n"
        else
          echo -e "$myResourceGroup is not created i.e. $myResourceGroup Resource Group already exists\n"
fi
echo -e "please provide the name of the cluster\n"
read myAKSCluster

echo -e "***************************************************"
echo -e "****Welcome to the Troubleshooting environment*****\n \n"
echo -e "Please select the troubleshooting session you would like to perform"
echo -e "**********************************************************************\n"
echo -e "#########Please find the below menu for troubleshooting########\n\n"
echo -e "*****************************************************************"
echo -e "*\t \t 1. Node not ready\t\t\t\t*"
echo -e "*\t \t 2. Cluster is in failed state\t\t\t*"
echo -e "*\t \t 3. Cluster Scaling issue\t\t\t*"
echo -e "*\t \t 4. Problem with accessing dashboard\t\t*"
echo -e "*\t \t 5. Cluster unable to communicate with API server"
echo -e "***************************************************************"

read option
case $option in
1)
az aks create \
    --resource-group $myResourceGroup \
    --name $myAKSCluster \
    --node-count 3 \
    --enable-addons monitoring \
    --generate-ssh-keys
echo -e "The cluster $myAKSCluster is created succefully \n"
MyVm=`kubectl get nodes | cut -d" " -f1 | grep -v NAME | head -1`
nodeResourceGroup=`az aks show --name $myAKSCluster -g $myResourceGroup | grep nodeResourceGroup | cut -d: -f2 | cut -d "\"" -f2`
echo -e "\n \n Please wait while we are preparing the environment for you to troubleshoot"
az vm run-command invoke -g $nodeResourceGroup -n $MyVm --command-id RunShellScript --scripts "sudo systemctl stop kubelet && sudo systemctl stop docker"
echo "Please Log in to the corresponding node and check basic services like kubectl, docker etc.."
;;
2)

echo -e "Please wait while the cluster is getting created"

az network vnet create --name customvnetlab2  --resource-group  $myResourceGroup --address-prefixes 20.0.0.0/26  --subnet-name customsubnetlab2 --subnet-prefixes 20.0.0.0/26
customsn=`az network vnet show -g $myResourceGroup -n customvnetlab2 | grep subnet | grep subscriptions | cut -d: -f2 | cut -d"," -f 1 | cut -d" " -f2 | cut -d"\"" -f2`
az aks create --resource-group $myResourceGroup --name $myAKSCluster --generate-ssh-keys -c 1 -s Standard_B2ms --network-plugin azure --vnet-subnet-id  $customsn
az aks scale -g $myResourceGroup -n $myAKSCluster -c 4 &> /dev/null
echo -e "********************************************************"
echo -e "********************************************************"
echo -e "********************************************************"
echo -e "********************************************************"
echo -e "********************************************************"
echo "It seems cluster is in failed state, please check the issue and resolve it appropriately"


;;
3)
echo -e "Please wait while the cluster is getting created"

az aks create \
    --resource-group $myResourceGroup \
    --name $myAKSCluster \
    --node-count 1 \
    --generate-ssh-keys

nodeResourceGroup=`az aks show --name $myAKSCluster -g $myResourceGroup | grep nodeResourceGroup | cut -d: -f2 | cut -d "\"" -f2`
MyNsg=`az network nsg list --resource-group  $nodeResourceGroup | grep AllowAzureLoadBalancerInBound | grep subscriptions | cut -d"/" -f9`


az network nsg rule create -g $nodeResourceGroup --nsg-name $MyNsg -n MyNsgRuleWithTags  --priority 400 --source-address-prefixes VirtualNetwork --destination-address-prefixes Internet   --destination-port-ranges "*" --direction Outbound --access Deny --protocol Tcp --description "Deny to Internet." &> /dev/null

az aks scale -g $myResourceGroup -n $myAKSCluster -c 2

echo "It seems the cluster is in failed state, please check the issue and resolve it appropriately"

;;
4)
echo "Please wait while we are creating the cluster for you"
az aks create \
    --resource-group $myResourceGroup \
    --name $myAKSCluster \
    --node-count 1 \
    --generate-ssh-keys

echo -e "Please try using kubernetes dashboard and try to create a pod called nginx in test namespace using the dashboard\n"
echo -e "\n Once the issue is resolved with dashboard, please use "validation.sh" script to validate the dashboard access"

;;
5)
echo "Please wait while we are creating the cluster for you"
az aks create \
    --resource-group $myResourceGroup \
    --name $myAKSCluster \
    --node-count 1 \
    --generate-ssh-keys

az aks get-credentials -g $myResourceGroup -n $myAKSCluster &>/dev/null
nodeResourceGroup=`az aks show --name $myAKSCluster -g $myResourceGroup | grep nodeResourceGroup | cut -d: -f2 | cut -d "\"" -f2`
MyVNet=`az resource list -g $nodeResourceGroup | grep "aks-vnet" | grep name | cut -d: -f2 | cut -d"\"" -f2`
az network vnet update -g $nodeResourceGroup -n $MyVNet --dns-servers 10.2.0.8 &>/dev/null
MyVm=`kubectl get nodes | grep "Ready" | cut -d" " -f1`
az vm restart -g $nodeResourceGroup -n $MyVm --no-wait
;;
*)
echo "You have selected a wrong option"
exit
;;
esac
