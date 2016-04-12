ssh pae
cd /bear/chenqy/linuxhistory

ssh pae
ssh lion
cd /store1/chenqy/linuxhistory

ssh pae
ssh bear
cd /store1/chenqy/linuxhistory
R

open pae
ssh lion
cd /store1/chenqy/linuxhistory


vim /etc/sysconfig/iptables

# work
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 28787 -j DNAT --to-destination 192.168.0.100:8787
/sbin/iptables -t nat -A POSTROUTING -d 192.168.0.4 -p tcp --dport 8787 -j SNAT --to 192.168.0.1
/sbin/service iptables save # /sbin/iptables-save
/sbin/service iptables restart

wsei192.168.7.10:28787
wpkupae:28787

# refer
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 63306 -j DNAT --to-destination 192.168.0.4:3306
/sbin/iptables -t nat -A POSTROUTING -d 192.168.0.4 -p tcp --dport 3306 -j SNAT --to 192.168.0.1


# try
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 28787 -j DNAT --to-destination 192.168.0.100:8787
/sbin/iptables -t nat -A POSTROUTING -d 192.168.0.100 -p tcp --dport 8787 -j SNAT --to 192.168.0.1
/sbin/service iptables save # /sbin/iptables-save
/sbin/service iptables restart

# try
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 38787 -j DNAT --to-destination 192.168.0.4:8787
/sbin/iptables -t nat -A POSTROUTING -d 192.168.0.4 -p tcp --dport 8787 -j SNAT --to 192.168.0.1
/sbin/service iptables save # /sbin/iptables-save
/sbin/service iptables restart

/sbin/iptables -t nat -A PREROUTING --dst 192.168.0.1 -p tcp --dport 38787 -j DNAT --to-destination 192.168.0.4:8787
/sbin/iptables -t nat -A POSTROUTING --dst 192.168.0.4 -p tcp --dport 8787 -j SNAT --to-source 192.168.0.1