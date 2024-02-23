#!/usr/local/bin/bash
ipfw -q -f flush
cmd="ipfw -q add"
pif="vtnet0"       # Private interface to gig
pif2="tun0"     # public interface name of ppp

/sbin/sysctl -w net.inet.ip.forwarding=1
/sbin/natd -interface $pif2
#/sbin/natd -f /etc/natd.conf

###############################################################################
source /etc/ip-list
#########################
#SSH
ssh_port=22
  ### Local

$cmd   00001   allow           all      from    any                     to      any                     via     lo0  
### DNS and check it
$cmd   00010   allow           udp     from    8.8.8.8          to      me              in      via     $pif2   setup   keep-state
$cmd   10201   allow           icmp    from    me               to      8.8.8.8         out     via     $pif2
$cmd   10202   allow           icmp    from    8.8.8.8          to      me              in      via     $pif2
### DNS END
$cmd   10381   allow           tcp     from    any              to      me      $ssh_port       in      via     $pif2    setup limit src-addr 2
$cmd   12400   allow           tcp     from    me               to      any             out     via     any      setup   keep-state uid root

################Start OF IPFW Rules 2nd network card ##############################
### DENY

$cmd     01012   deny     all from      172.0.0.0/8   to      any     in      via     $pif2   #RFC    1918    private                                 
$cmd     01013   deny     all from      10.0.0.0/8      to      any     in      via     $pif2   #RFC    1918    private                                 
$cmd     01014   deny     all from      127.0.0.0/8     to      any     in      via     $pif2   #loopback                                               
$cmd     01015   deny     all from      0.0.0.0/8       to      any     in      via     $pif2   #loopback                                               
$cmd     01016   deny     all from      169.254.0.0/16  to      any     in      via     $pif2   #DHCP   auto-config                                     
$cmd     01017   deny     all from      192.0.2.0/24    to      any     in      via     $pif2   #reserved       for     docs                            
$cmd     01018   deny     all from      204.152.64.0/23 to      any     in      via     $pif2   #Sun    cluster                                         
$cmd     01019   deny     all from      224.0.0.0/3     to      any     in      via     $pif2   #Class          D       &       multicast                       
$cmd     01020   deny     udp from      172.0.7.0/24   to      any     in      via     em1                                                     
$cmd     01022   deny     all from      192.168.1.0/24  to      any     in      via     em1                                                     
$cmd     01023   deny     tcp from      any             to      me      23      in      via     $pif    setup   limit src-addr  2                       
$cmd     01024   deny     tcp from      any             to      me      25      in      via     $pif   setup   keep-state                              
$cmd     01025   drop     tcp from      any             to      me      3306    in      via     $pif   setup   keep-state                              
$cmd     01026   deny     tcp from      any             to      me      143     in      via     $pif   setup   keep-state                              
$cmd     01027   deny     tcp from      any             to      me      110     in      via     $pif   setup   keep-state                              
$cmd     01028   deny     tcp from      any             to      any     113     in      via     $pif                                           
$cmd     01029   deny     tcp from      any             to      any     137     in      via     $pif                                           
$cmd     01030   deny     tcp from      any             to      any     138     in      via     $pif                                           
$cmd     01031   deny     tcp from      any             to      any     139     in      via     $pif                                           
$cmd     01032   deny     tcp from      any             to      any     81      in      via     $pif                                           
$cmd     01033   deny     all from      any             to      any     frag    in      via     any


# grep block  /etc/ip-list  | cut -d "=" -f 2  | sed 's/"/ /g'  | while read line ;do $cmd $n drop all from  $line to me via $pif2    ;done

$cmd   60000   divert 8668     all     from    any              to      any                     via     $pif2
