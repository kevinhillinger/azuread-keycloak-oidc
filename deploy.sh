#!/bin/bash

resourceGroupName=Keycloak
location=eastus

# vm keys

echo 'creating an SSH key pair'
ssh-keygen -f ./azure/keys/id_azure -m PEM -t rsa -b 4096
admin_public_key=$(cat ./azure/keys/id_azure.pub) 

# ensure resource group
echo 'Resource Group information.'
az group create -n $resourceGroupName -l $location

# vnet
echo 'Executing deployment for vnet'
az deployment group create \
--resource-group $resourceGroupName \
--name vnet-deployment \
--template-file "./azure/resources/vnet/deploy.json" \
--parameters "./azure/resources/vnet/parameters.json" 

# vm demployment
declare -a vm_list=("vm-wildfly" "vm-keycloak")

for tmpl in ${vm_list[@]}; do
   echo Executing deployment for $tmpl.
   az deployment group create \
    --resource-group $resourceGroupName \
    --name $tmpl-deployment \
    --template-file "./azure/resources/$tmpl/deploy.json" \
    --parameters "./azure/resources/$tmpl/parameters.json" \
    --parameters adminPublicKey="$admin_public_key" \
    --no-wait 
done