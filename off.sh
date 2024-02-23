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
#et -x -u -e
IF=tun0             # Interface
dst=$1
readonly sourceFile="/usr/local/bin/tcset"
source ${sourceFile}
echo "Got Disconnect command for ${common_name}" >> /var/log/ovpn/off 
echo "${common_name} : ${untrusted_ip} : ${ifconfig_pool_remote_ip}" >>/var/log/ovpn/off
/bin/bash /etc/openvpn/tc/DeleteKey.sh ${common_name} 
echo "sudo /usr/local/bin/tcset tun0 --rate 8bps  --network ${ifconfig_pool_remote_ip}/32 --change" >>/var/log/ovpn/log
sudo /usr/local/bin/tcset tun0 --rate 8bps  --network ${ifconfig_pool_remote_ip}/32 --change 2>>/var/log/ovpn/log
