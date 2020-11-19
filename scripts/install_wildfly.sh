#!/bin/bash

# install java
sudo apt-get update
sudo apt-get install default-jdk -y

java -version

# download
echo Downloading wildfly
wildfly_dist_url=https://download.jboss.org/wildfly/21.0.0.Final/wildfly-21.0.0.Final.tar.gz
cd /opt
sudo wget $wildfly_dist_url

# install
echo Extracting and installing wildfly...
sudo tar -xvzf wildfly-21.0.0.Final.tar.gz
sudo mv wildfly-16.0.0.Final /opt/wildfly

# security
# modify ownership and permission of /opt/wildfly/ directory and give executable permissions to /opt/wildfly/bin/ directory.
echo Creating Wildfly user and group.
sudo groupadd wildfly
sudo useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly
sudo chown -R wildfly: wildfly
sudo chmod o+x /opt/wildfly/bin/

# configuration
echo Configure and SystemD setup
cd /etc/
sudo mkdir wildfly
sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/
sudo cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/

# wildfly user as the owner of this script so that it can execute it:
sudo chown wildfly: /opt/wildfly/bin/launch.sh

echo Copying service def file
sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/

cat > /etc/systemd/system/wildfly.service <<EOF
[Unit]
Description=The WildFly Application Server
After=syslog.target network.target
Before=httpd.service

[Service]
Environment=LAUNCH_JBOSS_IN_BACKGROUND=1
EnvironmentFile=-/etc/wildfly/wildfly.conf
User=wildfly
Group=wildfly
LimitNOFILE=102642
PIDFile=/var/run/wildfly/wildfly.pid
ExecStart=/opt/wildfly/bin/launch.sh $WILDFLY_MODE $WILDFLY_CONFIG $WILDFLY_BIND
StandardOutput=null

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable wildfly

echo Starting wildfly
sudo systemctl start wildfly
sudo systemctl status wildfly

# Update management console binding
sudo echo '# The address console to bind to' >> /etc/wildfly/wildfly.conf
sudo echo 'WILDFLY_MANAGEMENT_CONSOLE_BIND=0.0.0.0' >> /etc/wildfly/wildfly.conf

sudo /opt/wildfly/bin/launch.sh


sudo systemctl daemon-reload