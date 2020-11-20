
admin=azureuser
admin_password=P@ssword1

./kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user $admin --password $admin_password

{
    # create realm
    ./kcadm.sh create realms -s realm=wildfly-realm -s enabled=true -o

    # add user
    ./kcadm.sh create users -r wildfly-realm -s username=customer-admin -s enabled=true
    ./kcadm.sh set-password -r wildfly-realm --username customer-admin --new-password admin
}