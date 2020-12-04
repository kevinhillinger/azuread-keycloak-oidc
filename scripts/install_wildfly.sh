#!/bin/bash

# install java
{
sudo apt-get update
sudo apt-get install default-jdk -y
java -version
}

# download and install
{
echo Downloading wildfly.
wildfly_dist_url=https://download.jboss.org/wildfly/21.0.0.Final/wildfly-21.0.0.Final.tar.gz
sudo wget $wildfly_dist_url

echo Installing.
sudo tar -xvzf wildfly-21.0.0.Final.tar.gz
sudo mv ./wildfly-21.0.0.Final /opt/wildfly
}

# security
{
echo Creating Wildfly user and group and granting permissions
sudo groupadd wildfly
sudo useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly

sudo chown -RH wildfly: wildfly
sudo chmod o+x /opt/wildfly/bin/
}

# configuration
{
echo Setting up conf and launch scripts.
sudo mkdir -p /etc/wildfly

cat > /tmp/wildfly.conf <<EOF
# The configuration you want to run
WILDFLY_CONFIG=standalone.xml

# The mode you want to run
WILDFLY_MODE=standalone

# The address to bind to
WILDFLY_BIND=0.0.0.0

# The address console to bind to
WILDFLY_MANAGEMENT_CONSOLE_BIND=0.0.0.0
EOF
sudo cp /tmp/wildfly.conf /etc/wildfly/
}

{
echo Launch settings

cat > /tmp/launch.sh <<EOF
#!/bin/bash

if [ "x\$WILDFLY_HOME" = "x" ]; then
    WILDFLY_HOME="/opt/wildfly"
fi

if [[ "\$1" == "domain" ]]; then
    \$WILDFLY_HOME/bin/domain.sh -c \$2 -b \$3 -bmanagement \$4
else
    \$WILDFLY_HOME/bin/standalone.sh -c \$2 -b \$3 -bmanagement \$4
fi
EOF
sudo cp /tmp/launch.sh /opt/wildfly/bin/

sudo sh -c 'chmod +x /opt/wildfly/bin/*.sh'
sudo chown wildfly: /opt/wildfly/bin/launch.sh
}

{
cat > /tmp/wildfly.service <<EOF
[Unit]
Description=The WildFly Application Server
After=syslog.target network.target
Before=httpd.service

[Service]
Environment=LAUNCH_JBOSS_IN_BACKGROUND=1
EnvironmentFile=-/etc/wildfly/wildfly.conf
User=wildfly
LimitNOFILE=102642
PIDFile=/var/run/wildfly/wildfly.pid
ExecStart=/opt/wildfly/bin/launch.sh \$WILDFLY_MODE \$WILDFLY_CONFIG \$WILDFLY_BIND \$WILDFLY_MANAGEMENT_CONSOLE_BIND
StandardOutput=null

[Install]
WantedBy=multi-user.target
EOF
sudo cp /tmp/wildfly.service /etc/systemd/system/
}

{
echo Reloading systemctl and starting service.
sudo systemctl daemon-reload
sudo systemctl enable wildfly
sudo systemctl start wildfly
sudo systemctl status wildfly --no-pager
}
#sudo tail -f /opt/wildfly/standalone/log/server.log

# done

# configuration
echo Adding Management Console binding...
sudo /opt/wildfly/bin/add-user.sh

