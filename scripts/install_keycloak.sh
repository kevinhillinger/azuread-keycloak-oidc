#!/bin/bash

{
sudo apt-get update
sudo apt-get install default-jdk -y
java -version
}

{
sudo wget https://downloads.jboss.org/keycloak/11.0.3/keycloak-11.0.3.tar.gz
sudo tar -xvzf keycloak-11.0.3.tar.gz
sudo mv ./keycloak-11.0.3 /opt/keycloak
}

{
sudo groupadd keycloak
sudo useradd -r -g keycloak -d /opt/keycloak -s /sbin/nologin keycloak
sudo chown -R keycloak: /opt/keycloak
sudo chmod o+x /opt/keycloak/bin/
}

{
sudo mkdir -p /etc/keycloak
sudo cp /opt/keycloak/docs/contrib/scripts/systemd/wildfly.conf /etc/keycloak/keycloak.conf

cat > /tmp/launch.sh <<EOF
#!/bin/bash

if [ "x\$WILDFLY_HOME" = "x" ]; then
    WILDFLY_HOME="/opt/keycloak"
fi

if [[ "\$1" == "domain" ]]; then
    \$WILDFLY_HOME/bin/domain.sh -c \$2 -b \$3
else
    \$WILDFLY_HOME/bin/standalone.sh -c \$2 -b \$3
fi
EOF
sudo cp /tmp/launch.sh /opt/keycloak/bin/
sudo chown keycloak: /opt/keycloak/bin/launch.sh
sudo sh -c 'chmod +x /opt/keycloak/bin/*.sh'
}

{
cat > /tmp/keycloak.service <<EOF
[Unit]
Description=The Keycloak Server
After=syslog.target network.target
Before=httpd.service

[Service]
Environment=LAUNCH_JBOSS_IN_BACKGROUND=1
EnvironmentFile=/etc/keycloak/keycloak.conf
User=keycloak
Group=keycloak
LimitNOFILE=102642
PIDFile=/var/run/keycloak/keycloak.pid
ExecStart=/opt/keycloak/bin/launch.sh \$WILDFLY_MODE \$WILDFLY_CONFIG \$WILDFLY_BIND
StandardOutput=null

[Install]
WantedBy=multi-user.target
EOF
sudo cp /tmp/keycloak.service /etc/systemd/system/keycloak.service
}

{
sudo systemctl daemon-reload
sudo systemctl enable keycloak
sudo systemctl start keycloak
sudo systemctl status keycloak --no-page
}



admin_password='<define admin password>'

{
    sudo /opt/keycloak/bin/add-user-keycloak.sh -r master -u azureuser -p $admin_password
    sudo systemctl restart keycloak
}

{
    sudo /opt/keycloak/bin/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user azureuser –-password $admin_password
    sudo /opt/keycloak/bin/kcadm.sh update realms/master -s sslRequired=NONE
}

# access at http://<instance-public-ip>:8080/auth/