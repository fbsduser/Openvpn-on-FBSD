 
#!/usr/bin/env bash
####################################################################
#                _          _   _           
#   ___ ___   __| | ___  __| | | |__  _   _ 
#  / __/ _ \ / _` |/ _ \/ _` | | '_ \| | | |
# | (_| (_) | (_| |  __/ (_| | | |_) | |_| |
#  \___\___/ \__,_|\___|\__,_| |_.__/ \__, |
#                                     |___/ 
#  _   _  _      _____      _  _       _____     _ 
# | |_| || | ___|___ /_   _| || |  _ _|___ /  __| |
# | __| || ||_  / |_ \ \ / / || |_| '__||_ \ / _` |
# | |_|__   _/ / ___) \ V /|__   _| |  ___) | (_| |
#  \__|  |_|/___|____/ \_/    |_| |_| |____/ \__,_|
#
# Wed Jun 12 12:03:52 2019
####################################################################
cd /usr/local/etc/openvpn/easy-rsa/
user=$1  dn=$2
#EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full $user  nopass >/dev/null 2>&1 OPENSSL OP CHANGED.escape shitf zz lolz
EASYRSA_CERT_EXPIRE=3650 ; cat << EOF | ./easyrsa build-client-full $user  nopass 
yes
EOF
###
file_="/usr/local/etc/openvpn/tc/users/$user"
#remote "`curl -s https://checkip.amazonaws.com`" 7612 
echo << EOF "
keycontentclient
dev tun
proto udp
sndbuf 0
rcvbuf 0
remote "`cat /root/m`" 7612
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA512
cipher AES-256-CBC
setenv opt block-outside-dns
key-direction 1
auth-nocache
verb 1
"\<ca\>"
`cat  /usr/local/etc/openvpn/easy-rsa/pki/ca.crt`
"\<\/ca\>"
"\<cert\>"
`sed -ne '/BEGIN CERTIFICATE/,$ p' /usr/local/etc/openvpn/easy-rsa/pki/issued/$user.crt`
"\<\/cert\>"
"\<key\>"
`cat /usr/local/etc/openvpn/easy-rsa/pki/private/$user.key`
"\</key\>"
"\<tls-auth\>" 
`sed -ne '/BEGIN OpenVPN Static key/,$ p' /usr/local/etc/openvpn/ta.key`
"\<\/tls-auth\>" 
"
EOF
echo 20mbps > $file_

