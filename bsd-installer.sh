#!/usr/bin/env bash
ntpdate -u pool.ntp.org
OVPN_PATH="/usr/local/etc/openvpn"
CLIENT=First_admin
#### first of all upgrade
[ -f  /root/update ] && ( [ ! -f /root/upgrade ] freebsd-update fetch ;freebsd-update install && touch /root/{update,upgrade] ; reboot )
[ -f /root/upgrade ] && ( freebsd-update install && reboot )
####
ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2 > /root/m

pkg -y update && pkg upgrade -y 

mkdir -p $OVPN_PATH/{easy-rsa,server,tc/users}
echo y | pkg install easy-rsa openvpn 

cp /usr/local/share/examples/openvpn/sample-config-files/server.conf $OVPN_PATHserver/
cp -r /usr/local/share/easy-rsa/* $OVPN_PATH/easy-rsa/
cp Key.sh on.sh off.sh $OVPN_PATH/tc
chmod 755 $OVPN_PATH/tc/*.sh
### make key
cd $OVPN_PATH/easy-rsa/
echo yes | ./easyrsa.real init-pki
./easyrsa.real --batch build-ca nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa.real build-server-full server nopass
EASYRSA_CERT_EXPIRE=3650 ./easyrsa.real build-client-full $CLIENT nopass
EASYRSA_CRL_DAYS=3650 ./easyrsa.real gen-crl
cp pki/ca.crt pki/private/ca.key pki/issued/server.crt pki/private/server.key pki/crl.pem $OVPN_PATH/ || echo "cp failure"
chown nobody:$GROUPNAME $OVPN_PATH/crl.pem
[ ! -f /usr/local/sbin/openvpn ]&& echo -e "\033[5;36m ERROR:  can not find /usr/local/sbin/openvpn ! \033[0m" 
openvpn  --genkey secret $OVPN_PATH/ta.key
openssl dhparam -out dh.pem 2048
mv dh.pem $OVPN_PATH/dh.pem


cat << EOF > $OVPN_PATH/openvpn.conf
port 7612
proto udp
dev tun
server 192.168.120.0 255.255.255.240

ca $OVPN_PATH/ca.crt
cert $OVPN_PATH/server.crt
key $OVPN_PATH/server.key
dh $OVPN_PATH/dh.pem
auth SHA512 
cipher AES-256-CBC
tls-auth ta.key 0
#ifconfig-pool-persist ipp.txt persist-key
persist-tun
# inactive 8
keepalive 10 60
reneg-sec 0
tun-mtu 1470
tun-mtu-extra 32
mssfix 1430
push "persist-key"
push "persist-tun"
push "redirect-gateway def1"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
status /var/log/ovpn.log
verb 4
#duplicate-cn
script-security 2
#client-config-dir ccd
crl-verify $OVPN_PATH/crl.pem
down-pre
EOF

echo "openvpn_enable=YES" >> /etc/rc.conf
/usr/local/etc/rc.d/openvpn start 
