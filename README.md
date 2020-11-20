# Azure with Keycloak

## Getting started

- Clone the repository
- Execute the ```deploy.sh``` script 

```bash
git clone
cd azuread-keycloak-oidc
./deploy.sh
```

This will create a resource group _Keycloak_ with all the resources into it.

## Accessing the VMs

Wildfly: http://<instance-public-ip>:8080/
Keycloak: http://<instance-public-ip>:8080/auth/

## Keycloak Azure AD Setup
Once the Keycloak server is setup, navigate to it from a browser and login.

-   Create realm 'app-realm'
-   Select Identity Providers and add "Keycloak OpenID Connect"
-   

# Resources

## Installing Wildfly
-   [Install JBoss Wildfly on Ubuntu 18.04](https://medium.com/@hasnat.saeed/install-jboss-wildfly-on-ubuntu-18-04-ac00719a2f02)
-   [Install JBoss Wildfly on Ubuntu 18.04](https://linuxize.com/post/how-to-install-wildfly-on-ubuntu-18-04/)

## Keycloak
-   [Keycloak Quickstarts](https://github.com/keycloak/keycloak-quickstarts)
-   [Setting up Keycloak Server](https://medium.com/@hasnat.saeed/setup-keycloak-server-on-ubuntu-18-04-ed8c7c79a2d9)
-   [SSL Self Signed Cert for KeyCloak Server](https://wjw465150.gitbooks.io/keycloak-documentation/content/server_installation/topics/network/https.html)
-   [Install Keycloak OpenID Connect Client Adapter on Wildfly on Ubuntu 18.04](https://medium.com/@hasnat.saeed/install-keycloak-openid-connect-client-adapter-on-wildfly-on-ubuntu-18-04-ef98a99fc528)
-   [Wildfly Keycloak Adapter](https://www.keycloak.org/docs/latest/securing_apps/#_jboss_adapter)

https://quarkus.io/guides/security-openid-connect
https://github.com/quarkusio/quarkus-quickstarts/tree/master/security-openid-connect-quickstart
https://quarkus.io/guides/security-keycloak-authorization
https://github.com/dasniko/keycloak-javaee-demo

## Azure VMs and SSH keys
-   [Create and use an SSH public-private key pair for Linux VMs in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/mac-create-ssh-keys)