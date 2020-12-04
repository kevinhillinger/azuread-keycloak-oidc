
# in keycloak server, generate self signed cert and point keycloak config to use it

keycloak_endpoint_name=''
cn=$keycloak_endpoint_name.eastus.cloudapp.azure.com
keystore=keycloak.jks

# create cert
sudo keytool -genkey -alias $cn -dname "cn=$cn,o=Acme,c=GB" -keyalg  RSA -keystore $keystore -validity 365  -keysize 2048

# in wildfly server, import cert to ca
{
    #Export Self signed certificate into .cer file
    cer=keycloak.cer
    sudo keytool -exportcert -alias $cn -keystore $keystore -file $cer

    # Install self-signed certificate into Java JDK CA Certificate key store
    sudo keytool -delete -cacerts -alias $cn 
    sudo keytool -import -cacerts -alias $cn -file $cer

    # List certificates stored in JDK Key store
    sudo keytool -list -cacerts -alias $cn
}