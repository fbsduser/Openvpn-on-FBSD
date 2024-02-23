#!/bin/bash
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
#  kbps: Kilobytes per second
#  mbps: Megabytes per second
#  kbit: Kilobits per second
#  mbit: Megabits per second
#  bps: Bytes per second
#       kb or k: Kilobytes
#       mb or m: Megabytes
#       mbit: Megabits
#       kbit: Kilobits
#
####################################################################
exec 5> >(logger -t $0)
BASH_XTRACEFD="5"
PS4='$LINENO: '


IF=tun0             # Interface
IP=$1               # Host IP

echo "${common_name} : ${untrusted_ip} : ${ifconfig_pool_remote_ip}" >>/var/log/ovpn/on
echo "sudo tcset tun0 --rate $value  --network ${ifconfig_pool_remote_ip}/32 --change" >>/var/log/ovpn/on_log
sudo tcset tun0 --rate $value  --network ${ifconfig_pool_remote_ip}/32 --change >>/var/log/ovpn/on_log

