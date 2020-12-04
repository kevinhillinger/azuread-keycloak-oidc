# Keycloak Integration with Azure Active Directory using OIDC

This sample demonstrates a setup of two VMs. One is the Keycloak node and the other the Wildfly node. Each are standalone mode for demonstration purposes. 

The sample assumes the following:

-   Little to no understanding of Keycloak
-   You understand how to setup and configure Wildfly
-   Use Maven to build and deploy an application to it
-   Have an Azure subscription and know how to create resources like VMs at a basic level

## Getting started

- Clone the repository
- Execute the ```deploy.sh``` script to stand up all the resources in Azure

```bash
git clone
cd azuread-keycloak-oidc
./deploy.sh
```

This will create a resource group _Keycloak_ with all the resources into it. The setup is simple and looks like the below

## Accessing the VMs

Wildfly: http://<instance-public-ip>:8080/
Keycloak: http://<instance-public-ip>:8080/auth/

## Keycloak Azure AD Setup
Once the Keycloak server is setup, navigate to it from a browser and login.

-   Create realm 'app-realm'
-   Select Identity Providers and add "OpenID Connect"


# Resources

-   [Keycloak Quickstarts](https://github.com/keycloak/keycloak-quickstarts)
-   [Install JBoss Wildfly on Ubuntu 18.04](https://linuxize.com/post/how-to-install-wildfly-on-ubuntu-18-04/)
-   [Install Keycloak OpenID Connect Client Adapter on Wildfly on Ubuntu 18.04](https://medium.com/@hasnat.saeed/install-keycloak-openid-connect-client-adapter-on-wildfly-on-ubuntu-18-04-ef98a99fc528)
-   [Wildfly Keycloak Adapter](https://www.keycloak.org/docs/latest/securing_apps/#_jboss_adapter)
-   [SSL Self Signed Cert for KeyCloak Server](https://wjw465150.gitbooks.io/keycloak-documentation/content/server_installation/topics/network/https.html)
