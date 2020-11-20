#!/bin/bash

{
cd /opt/wildfly
sudo wget https://downloads.jboss.org/keycloak/11.0.3/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-11.0.3.tar.gz
sudo tar -xvzf keycloak-wildfly-adapter-dist-11.0.3.tar.gz
sudo rm keycloak-wildfly-adapter-dist-11.0.3.tar.gz
}

{
sudo systemctl daemon-reload
sudo systemctl restart wildfly
sudo ./bin/jboss-cli.sh -c --file=bin/adapter-elytron-install.cli
sudo systemctl restart wildfly
}