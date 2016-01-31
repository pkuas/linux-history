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



/sbin/iptables -t nat -A PREROUTING -p tcp --dport 28787 -j DNAT --to-destination 192.168.0.100:8787
/sbin/iptables -t nat -A POSTROUTING -d 192.168.0.4 -p tcp --dport 8787 -j SNAT --to 192.168.0.1
/sbin/service iptables save # /sbin/iptables-save
/sbin/service iptables restart

wsei192.168.7.10:28787
wpkupae:28787

# refer
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 63306 -j DNAT --to-destination 192.168.0.4:3306
/sbin/iptables -t nat -A POSTROUTING -d 192.168.0.4 -p tcp --dport 3306 -j SNAT --to 192.168.0.1
