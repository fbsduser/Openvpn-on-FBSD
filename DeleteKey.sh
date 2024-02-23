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
user=$1
[ $1 = ad5 ]&&echo exit
[ ! "`grep -w  "CN=$user" /usr/local/etc/openvpn/easy-rsa/pki/index.txt`"  ]&& echo "$user not found" && exit
set -x -u -e 

nat_ip="`grep -w ^$user /var/log/ovpn/on | awk {' print $5 '}`"
real_ip="`grep -w ^$user /var/log/ovpn/on | awk {' print $3 '}`"

echo "Got Disconnect+DELKEY command for $user" >> /var/log/ovpn/del_log
#echo "$user $nat_ip $real_ip" >> /etc/openvpn/del_log
echo "$user $nat_ip $real_ip" >> /var/log/ovpn/del_log
echo yes | ./easyrsa.real revoke $user                   >/dev/null 2>&1
cd /usr/local/etc/openvpn/easy-rsa/
EASYRSA_CRL_DAYS=3650 ./easyrsa.real gen-crl  >/dev/null 2>&1
rm -f /usr/local/etc/openvpn/crl.pem
cp /usr/local/etc/openvpn/easy-rsa/pki/crl.pem /usr/local/etc/openvpn/crl.pem
chown nobody:nogroup   /usr/local/etc/openvpn/crl.pem
    
