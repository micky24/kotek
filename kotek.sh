#!/bin/bash
# Enter [q] to quit! anyway, me, 'micky" not giving any warranty & responsibility to anything! and to any damage on your system. proceed at your own risk.
function s3 { sleep 3; }; 
function t { cd ~; ./kotek.sh; }; 
function i_t { executable=$1; apt-get update; apt-get install $1 -y; } ; function p_i { echo; echo -e "\033[1;37m$1 
"; }; function e_e { i_t "zlib1g-dev libpam0g-dev libssl-dev openssl build-essential gcc" ; }; if [ ! -f /etc/debian_version ]; then p_i " Debian 6/7 only!"; s3; exit; fi; if [ $USER \
!= 'root' ]; then echo " Run as root!"; s3; exit; fi; function r_v { executable=$1; apt-get remove --purge $1 -y; }; function r_e { executable=$1; dpkg -l | grep -i "$1"; apt-get aut\
oremove -y; }; function a_b { if [ $ADDPORT = 'q' ]; then echo "  Aborting!"; s3; t; fi; }; function a_t { read -p ") Enter addition port [123]|[q]: " -r ADDPORT; }; function o_v { function \
w_v { if [ ! -e /etc/openvpn/ ]; then echo ") Install OpenVPN first"; s3; o_v; fi; }; function a_v { p2=`echo ${PORT:0:2}`; sed -i 's|;cipher AES-128-CBC   # AES|cipher AES-128-CBC   # AES|' \
$TYPE$PORT.conf; sed -i 's|;push "redirect-gateway def1 bypass-dhcp"|push "redirect-gateway def1 bypass-dhcp"|' $TYPE$PORT.conf; 
sed -i 's|;push "dhcp-option DNS 208.67.220.220"|push "dhcp-option DNS 8.8.8.8"|' $TYPE$PORT.conf; sed -i 's|port 1194|port '$PORT'|' $TYPE$PORT.conf; sed\
 -i 's|proto udp|proto '$TYPE'|' $TYPE$PORT.conf; sed -i 's|server 10.8.0.0 255.255.255.0|server 10.8.'$p2'.0 255.255.255.0|' $TYPE$PORT.conf; iptables -t nat -A POSTROUTING -s 10.8.$p2.0/24 \
-j SNAT --to $IP; sed -i "/# By default this script does nothing./a\iptables -t nat -A POSTROUTING -s 10.8.$p2.0/24 -j SNAT --to $IP" /etc/rc.local; }; function d_m { echo; read -p "  Enter y\
our server IP address: " -e -i $IP IP; echo; read -p "  Enter OpenVPN protocol e.g[udp|tcp]: " -e -i tcp TYPE; echo; read -p "  Enter OpenVPN port e.g: " -e -i 143 PORT; }; function ov { CN=/\
root/$CLIENT-$TYPE$PORT.ovpn; echo $1 >> $CN; }; function cli_ent { cd /etc/openvpn/easy-rsa/2.0/keys; ov "client"; ov "dev tun"; ov "proto $TYPE"; ov "remote $IP $PORT"; ov "resolv-retry inf\
inite"; ov "nobind"; ov "persist-key"; ov "persist-tun"; ov "ns-cert-type server"; ov "cipher AES-128-CBC"; ov "comp-lzo"; ov "verb 3"; ov "<ca>"; cat ca.crt >> $CN; ov "</ca>"; ov "<cert>"
cat $CLIENT.crt >> $CN; ov "</cert>"; ov "<key>"; cat $CLIENT.key >> $CN; ov "</key>"; }; if [ ! -e /dev/net/tun ]; then clear; p_i "  TUN/TAP is not available!"; s3; ./tsvpn; fi; echo "$(gr\
ep address /etc/network/interfaces | grep -v 127.0.0.1  | awk '{print $2}' | grep -q '.' | head -1)"; IP=$(grep address /etc/network/interfaces | grep -v 127.0.0.1  | awk '{print $2}' | grep \
'.' | head -1); clear; echo "################################################################################"; echo "#   OpenVPN With Additional Protocol & Port Selection Quick Installer Scr\
ipt.  #"; echo "#     No warranty to any damage on your system, proceed at your own risk!      #"; echo "################################################################################"; ech\
o; echo; echo "   1) Un|Install OpenVPN"; echo "   2) Add|Remove port"; echo "   3) Add|Revoke cert"; p_i "   0) Back to main ./kotek.sh"; read -p "  Select an option [0-3]: " -n 1 -r option
case $option in 1)if [ -e /etc/openvpn ]; then read -p ") Uninstall OpenVPN? [y/n]: " -n 1 -r; echo; if [[ $REPLY =~ ^[Yy]$ ]]; then sed -i '/iptables -t nat -A POSTROUTING -s 10.8.'g_t'.0/d'\
 /etc/rc.local; service openvpn stop; r_v openvpn\*; r_e openvpn; rm -rf /etc/openvpn /usr/share/doc/openvpn; p_i "  Done uninstalling OpenVPN"; s3; o_v; else echo "  Aborting!"; s3; o_v; fi
fi; echo; d_m; echo; read -p "  Enter client name e.g: " -e -i micky CLIENT; echo; i_t "openvpn iptables openssl"; cp -R /usr/share/doc/openvpn/examples/easy-rsa/ /etc/openvpn; cd /etc/open\
vpn/easy-rsa/2.0/; cp -u -p openssl-1.0.0.cnf openssl.cnf; . /etc/openvpn/easy-rsa/2.0/vars; . /etc/openvpn/easy-rsa/2.0/clean-all; export EASY_RSA="${EASY_RSA:-.}"; "$EASY_RSA/pkitool" --ini\
tca $*; export EASY_RSA="${EASY_RSA:-.}"; "$EASY_RSA/pkitool" --server server; export KEY_CN="$CLIENT"; export EASY_RSA="${EASY_RSA:-.}"; "$EASY_RSA/pkitool" $CLIENT; . /etc/openvpn/easy-rsa/\
2.0/build-dh; cd /usr/share/doc/openvpn/examples/sample-config-files; gunzip -d server.conf.gz; cp server.conf /etc/openvpn/$TYPE$PORT.conf; cp server.conf /etc/openvpn/.server; cd /etc/openv\
pn/easy-rsa/2.0/keys; cp ca.crt ca.key dh1024.pem server.crt server.key /etc/openvpn; cd /etc/openvpn/; a_v; touch /etc/openvpn/.$TYPE$PORT.dummy; cli_ent; cd ~; clear; /etc/init.d/openvpn re\
start; netstat -tulpn; echo; echo "  Done installing OpenVPN"; echo "  OpenVPN config for $CLIENT available at ~/$CLIENT-$TYPE$PORT.ovpn"; echo "  Running on $TYPE $IP:$PORT"; read -p "  Back\
 to main [enter]: "; o_v;; 2)w_v; echo; d_m; if [ -e /etc/openvpn/.$TYPE$PORT.dummy ]; then echo; read -p "  $TYPE$PORT already added, remove? [y/n]: " -n 1 -r; echo; if [[ $REPLY =~ ^[Yy]$ ]]
then p2=`echo ${PORT:0:2}`; sed -i '/iptables -t nat -A POSTROUTING -s 10.8.'$p2'.0/d' /etc/rc.local; rm -rf /etc/openvpn/.$TYPE$PORT.dummy etc/openvpn/$TYPE$PORT.conf; service openvpn restar\
t; netstat -tulpn; p_i "  Done removing $TYPE$PORT"; s3; o_v; else echo "  Aborting!"; s3; o_v; fi; fi; cd /etc/openvpcp .server $TYPE$PORT.conf; a_v; mkdir /etc/openvpn/.$TYPE$PORT.dummy; se\
rvice openvpn restart; netstat -tulpn; echo; echo "  Protocol $TYPE & port $PORT added"; echo "  You need to edit or duplicate the config on client"; echo "  Change the protocol to [$TYPE] & \
port to [$PORT]"; read -p "  Back to main [enter]: "; o_v;; s3)w_v; echo; echo; read -p "  Enter client name e.g.: " -e -i micky CLIENT; if [ -e /etc/openvpn/easy-rsa/2.0/keys/$CLIENT.crt ]
then echo; read -p "  Found $CLIENT cert, revoke? [y/n]: " -n 1 -r; echo; if [[ $REPLY =~ ^[Yy]$ ]]; then cd /etc/openvpn/easy-rsa/2.0/; . /etc/openvpn/easy-rsa/2.0/vars; . /etc/openvpn/easy-\
rsa/2.0/revoke-full $CLIENT; rm -rf $CLIENT.crt $CLIENT.key; cd ~; rm -rf $CLIENT-$TYPE$PORT.ovpn; p_i "  Done revoking $CLIENT cert"; s3; o_v; else echo "  Aborting!"; s3; o_v; fi; fi; d_m
if [ ! -e /etc/openvpn/.$TYPE$PORT.dummy ]; then echo; echo "  protocol $TYPE & port $PORT not available!"; echo "  To see active OpenVPN protocol and port,"; echo "  Enter command [netstat -\
tulpn]"; s3; o_v; fi; cd /etc/openvpn/easy-rsa/2.0/; source ./vars; export KEY_CN="$CLIENT"; export EASY_RSA="${EASY_RSA:-.}"; "$EASY_RSA/pkitool" $CLIENT; cli_ent; echo; echo "  Done adding \
cert for $CLIENT"; echo "  $CLIENT config available at ~/$CLIENT-$TYPE$PORT.ovpn"; read -p "  Back to main [enter]: "; o_v;; 0)t;; esac; echo "  Can't find that option!"; s3; o_v; }; function\
 add_ports { sed -i 's|Port.*|Port '$PORT'|' /etc/ssh/sshd_config; service ssh restart; }; function ssh_one { read -p ") Enter OpenSSH port [123]|[q]: " -r PORT; a_b; if [ ! -e /usr/local/sr\
c/61 ]; then e_e; cd /usr/local/src; wget toekang.tk/61; wget toekang.tk/13v14; fi; cd /usr/local/src/; tar -xzvf 61; cd openssh-6.1p1; zcat /usr/local/src/13v14 | patch; ./configure --\
prefix=/usr/local/src --sysconfdir=/etc/ssh --bindir=/usr/bin/ --sbindir=/usr/sbin --with-pam --with-4in6; make; make install; chown root:root -R /usr/local/src/openssh-6.1p1; add_ports; }
function ssh_two { read -p ") Enter OpenSSH port [123]|[q]: " -r PORT; a_b; if [ ! -e /usr/local/src/66 ]; then e_e; cd /usr/local/src; wget toekang.tk/66; fi; cd /usr/local/src; tar -xzf \
66; cd openssh-6.6p1; ./configure --prefix=/usr/local/src --sysconfdir=/etc/ssh --bindir=/usr/bin/ --sbindir=/usr/sbin --with-pam --with-4in6; make; make install; chown root:root -R /usr/loca\
l/src/openssh-6.6p1; add_ports; }; function res_def { read -p ") Restore OpenSSH, port [123]|[q]: " -r PORT; a_b; cd ~; rm -rf etc/ssh/* /usr/local/versions /usr/local/src/{openssh-6.1p1,open\
ssh-6.6p1,share,libexec}; rm -f /usr/local/bin/{scp,sftp,slogin,ssh,ssh-add,ssh-agent,ssh-keygen,ssh-keyscan}; r_v openssh-server\*; r_e openssh-server; i_t openssh-server; add_ports; ssh -V
p_i "  OpenSSH restored & running on port $PORT"; s3; t; }; function adp_ssh { if [ ! -e /etc/ssh/sshd_not_to_be_run ]; then a_t; a_b; if [ -e /etc/ssh/.$ADDPORT ]; then read -p "  Remov\
e port $ADDPORT? [y/n]: " -n 1 -r; if [[ $REPLY =~ ^[Yy]$ ]]; then sed -i 's/^Port '$ADDPORT'//' /etc/ssh/sshd_config; rm -rf /etc/ssh/.$ADDPORT; service ssh restart; netstat -tulpn; p_i "  P\
ort $ADDPORT removed!"; s3; t; else echo "  Aborting!"; s3; t; fi; fi; echo "Port $ADDPORT" >> "/etc/ssh/sshd_config"; touch /etc/ssh/.$ADDPORT; service ssh restart; netstat -tulpn; p_i "  Po\
rt $ADDPORT added!"; s3; t; else echo "  Dropbear running instead!"; s3; t; fi; }; function adp_drb { if [ -e /etc/ssh/sshd_not_to_be_run ]; then a_t; a_b; if [ -e /etc/dropbear/.$ADDPORT ]
then read -p "  Remove port $ADDPORT? [y/n]: " -n 1 -r; if [[ $REPLY =~ ^[Yy]$ ]]; then sed -i 's/^DROPBEAR_EXTRA_ARGS="-p '$ADDPORT'"/DROPBEAR_EXTRA_ARGS="-p "/' /etc/default/dropbear; rm -r\
f /etc/dropbear/.$ADDPORT; service dropbear restart; netstat -tulpn; p_i "  Port $ADDPORT removed!"; s3; t; else echo "  Aborting!"; s3; t; fi; fi; sed -i 's/^DROPBEAR_EXTRA_ARGS="-p [0-9]*"/\
DROPBEAR_EXTRA_ARGS="-p '$ADDPORT'"/' /etc/default/dropbear; touch /etc/dropbear/.$ADDPORT; service dropbear restart; netstat -tulpn; p_i "  Port $ADDPORT added!"; s3; t; else echo ") Install\
 Dropbear first!"; s3; t; fi; }; function adp_3pr { if [ -e /etc/3proxy/3proxy.cfg ]; then a_t; a_b; if [ -e /etc/3proxy/.$ADDPORT ]; then read -p "  Remove port $ADDPORT? [y/n]: " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then service 3proxy stop; sed -i 's/^proxy -n -p'$ADDPORT' -a//' /etc/3proxy/3proxy.cfg; rm -rf /etc/3proxy/.$ADDPORT; s3; service 3proxy start; p_i "  Port $ADDPOR\
T removed!"; s3; t; else echo "  Aborting!"; s3; t; fi; fi; service 3proxy stop; echo "proxy -n -p$ADDPORT -a" >> "/etc/3proxy/3proxy.cfg"; touch /etc/3proxy/.$ADDPORT; service 3proxy start
p_i "  Port $ADDPORT added!"; s3; t; else echo "  Install 3proxy first!"; s3; t; fi; }; p_i ""; function s_1 { function i_nd { rm -rf  /etc/init.d/vpnserver
cat > /etc/init.d/vpnserver <<END
#!/bin/sh
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    \$remote_fs $syslog
# Required-Stop:     \$remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable Softether by daemon.
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
test -x \$DAEMON || exit 0
case "\$1" in
start)
\$DAEMON start
touch \$LOCK
;;
stop)
\$DAEMON stop
rm \$LOCK
;;
restart)
\$DAEMON stop
sleep 3
\$DAEMON start
;;
*)
echo "Usage: \$0 {start|stop|restart}"
exit 1
esac
exit 0
END
}
clear; echo "########################################################################\
########"; echo "#        SoftetherVPN Server For Intel x86-32bit Quick Installer Script.       #"; echo "#      No warranty to any damage on your system, proceed at your own risk!     #"; echo "##################\
##############################################################"; echo; echo; echo "   1) Un|Install SoftetherVPN         2) Un|Install Using Local Bridge"; 
echo; echo "   0) Back to main ./kotek.sh"; echo; read -p "  Select an option [0-2]: " -n 1 -r option
case $option in 1)if [ -e /etc/init.d/vpnserver ]; then read -p ") Uninstall SoftetherVPN? [y/n]: " -n 1 -r; echo; if [[ $REPLY =~ ^[Yy]$ ]]; then service vpnserver stop; rm -rf /usr/local/vpnserver /etc/init.d/v\
pnserver; p_i "  Done uninstalling SoftetherVPN"; s3; s_1; else echo "  Aborting!"; s3; s_1; fi;  
else
cd ~; apt-get update; 
apt-get install build-essential expect -y
if [ ! -e ~/sof ]; then
wget -O sof http://www.softether-download.com/files/softether/v4.21-9613-beta-2016.04.24-tree/Linux/SoftEther_VPN_Server/32bit_-_Intel_x86/softether-vpnserver-v4.21-9613-beta-2016.04.24-linux-x86-32bit.tar.gz ; fi
tar zxf sof
rm sof
cd vpnserver
so1=$(expect -c "
spawn make; sleep 1
expect \"\"; sleep 6; send \"1\r\"; 
expect \"\"; sleep 3; send \"1\r\"; 
expect \"\"; sleep 3; send \"1\r\";
expect eof; "); echo "$so1"
cd ..
mv vpnserver /usr/local
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpncmd
chmod 700 vpnserver
i_nd
chmod 755 /etc/init.d/vpnserver
mkdir /var/lock/subsys
update-rc.d vpnserver defaults
/etc/init.d/vpnserver start
cd /usr/local/vpnserver/
so3=$(expect -c "
spawn ./vpncmd; sleep 3
expect \"\"; send \"3\r\"; sleep 3
expect \"\"; send \"check\r\"; sleep 3
expect eof; ")
echo "$so3"
so4=$(expect -c "
spawn ./vpncmd; sleep 3
expect \"\";  sleep 3; send \"1\r\"
expect \"\";  sleep 3; send \"localhost:5555\r\"
expect \"\";  sleep 3; send \"\r\"
expect \"\";  sleep 3; send \"ServerPasswordSet\r\"
expect \"\";  sleep 3; send \"12345\r\"
expect \"\";  sleep 3; send \"12345\r\"
expect eof; ")
echo "$so4"
/etc/init.d/vpnserver restart
echo "default password is set to 12345 you may change it later"; sleep 5
netstat -tulpn; s3; cd ~; s_1
fi;;
2)if [ -e /etc/dnsmasq.conf ]; then read -p ") Uninstall SoftetherVPN Using Local Bridge? [y/n]: " -n 1 -r; echo; if [[ $REPLY =~ ^[Yy]$ ]]; then cd ~; /etc/init.d/vpnserver stop; /etc/init.d/dnsmasq stop; i_nd
apt-get remove --purge  iptables-persistent\* dnsmasq\* -y; apt-get autoremove -y
p_i "  Done uninstalling SoftetherVPN Using Local Bridge"; s3; s_1; else echo "  Aborting!"; s3; s_1; fi; 
else
IP=$(grep address /etc/network/interfaces | grep -v 127.0.0.1  | awk '{print $2}' | grep '.' | head -1)
ifconfig tap_soft; sleep 5; 
apt-get update; apt-get install dnsmasq -y
echo interface=tap_soft >> /etc/dnsmasq.conf
echo dhcp-range=tap_soft,10.8.0.3,10.8.0.253,1h >> /etc/dnsmasq.conf
echo dhcp-option=tap_soft,3,10.8.0.1 >> /etc/dnsmasq.conf
rm -rf  /etc/init.d/vpnserver
cat > /etc/init.d/vpnserver <<END
#!/bin/sh
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable Softether by daemon.
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver
TAP_ADDR=10.8.0.1

test -x \$DAEMON || exit 0
case "\$1" in
start)
\$DAEMON start
touch \$LOCK
sleep 1
/sbin/ifconfig tap_soft \$TAP_ADDR
;;
stop)
\$DAEMON stop
rm \$LOCK
;;
restart)
\$DAEMON stop
sleep 3
\$DAEMON start
sleep 1
/sbin/ifconfig tap_soft \$TAP_ADDR
;;
*)
echo "Usage: \$0 {start|stop|restart}"
exit 1
esac
exit 0
END
chmod 755 /etc/init.d/vpnserver
rm -rf /etc/sysctl.d/ipv4_forwarding.conf
cat > /etc/sysctl.d/ipv4_forwarding.conf <<END
net.ipv4.ip_forward = 1
END
sysctl --system; sleep 5
iptables -t nat -A POSTROUTING -s 192.168.91.0/24 -j SNAT --to-source $IP
apt-get install iptables-persistent
iptables-save < /etc/iptables.up.rules
/etc/init.d/vpnserver restart
/etc/init.d/dnsmasq restart
netstat -tulpn; sleep 3; s_1; cd ~;fi ;;
0)t;; esac; echo "  Can't find that option!"; s3; s_1; }; 
clear; echo "################################################################################"
echo "# OpenSSH6.1p1-HPN13v14-6.6p1-OpenVPN-Dropbear-3Proxy-Squid Proxy-SoftetherVpn #"; echo "#     No warranty to any damage on your system, proceed at your own risk!      #"; echo "#######\
#########################################################################"; echo; echo; echo "   1) Un|Install OpenSSH_6.6p1           6) Softether VPN Server"; echo "   2) Un|Install OpenSSH6.1p\
1-HPN13v14   7) Add|Remove OpenSSH addition port"; echo "   3) Un|Install Dropbear_2014.63        8) Add|Remove Dropbear addition port"; echo "   4) Un|Install 3Proxy                  9) Add|\
Remove 3Proxy addition port"; echo "   5) Un|Install OpenVPN                 0) Server Speedtest"; echo "   S) Un|Install Squid Proxy";
echo; echo "   ./kotek.sh"; echo; read -p "  Select an option [0-9]|[ctrl+c]: " -n 1 -r option; case $option in 7)ad\
p_ssh;; 8)adp_drb;; 9)adp_3pr;; 2)if [ -e /usr/local/src/openssh-6.6p1 ]; then echo "  Uninstall OpenSSH6.6p1 first!"; t; else if [ ! -e /usr/local/src/openssh-6.1p1 ]; then ssh_one; ssh -V
p_i "  OpenSSH6.1p1-HPN13v14 installed & running on port $PORT"; s3; t; else res_def; t; fi; fi;; 1)if [ -e /usr/local/src/openssh-6.1p1 ]; then echo ") Uninstall OpenSSH6.1p1-HPN13v14 first!"
s3; t; else if [ ! -e /usr/local/src/openssh-6.6p1 ]; then ssh_two; add_ports; service ssh restart; ssh -V; p_i "  OpenSSH6.6p1 installed & running on port $PORT"; s3; t; else res_def; t; fi
fi;; 

3)if [ ! -e /etc/default/dropbear ]; then read -p ") Enter Dropbear port [123]|[q]: " -r PORT; a_b; e_e; i_t dropbear; cd /usr/local/src; wget toekang.tk/d63; tar xvfj d63; chown -R root\
:root dropbear-2014.63; cd dropbear-2014.63; ./configure; make; make install; ab="/etc/default/dropbear"; sed -i 's|NO_START=1|NO_START=0|' $ab; sed -i 's|DROPBEAR_PORT=22|DROPBEAR_PORT='$POR\
T'|' $ab; sed -i 's|DROPBEAR_EXTRA_ARGS=|DROPBEAR_EXTRA_ARGS="-p "|' $ab; sed -i 's|DAEMON=/usr/sbin/dropbear|DAEMON=/usr/local/src/dropbear-2014.63/dropbear|' /etc/init.d/dropbear; service d\
ropbear restart; netstat -tulpn; p_i "  Dropbear installed & running on port $PORT"; s3; t; fi; if [ -e /etc/default/dropbear ]; then read -p ") Uninstall Dropbear? [y/n]: " -n 1 -r; if [[ $R\
EPLY =~ ^[Yy]$ ]]; then echo; service dropbear stop; aa=`find / -name dropbear`; rm -rf /etc/ssh/sshd_not_to_be_run $aa /usr/local/src/{dropbear-2014.63,d63}; r_v dropbear\*; r_e dropbear; ser\
vice ssh start; netstat -tulpn; p_i " Done uninstalling Dropbear"; s3; t; else echo "  Aborting!"; s3; t; fi; fi;; 

4)if [ ! -e /etc/3proxy/3proxy.cfg ]; then read -p ") Enter 3proxy port [123]|[q]: " -r PORT; a_b; 
cd /usr/local/src; wget toekang.tk/3; tar -xvzf 3; rm -rf 3; cd 3proxy-0.6.1; e_e; 
make -f Makefile.Linux; mkdir /etc/3proxy; mv /usr/local/src/3proxy-0.6.1/src/3proxy /etc/3proxy; 
cd /etc/3proxy; touch /etc/3proxy/3proxy.cfg; touch /etc/3proxy/.$PORT; touch /var/log/3proxy.log; touch /etc/3proxy/3proxy.cfg
#function 3p { echo $1 >> "/etc/3proxy/3proxy.cfg"; }; 3p "daemon"; 3p "nserver 8.8.8.8"; 3p "nscache 65536"; 3p "timeouts 1 5 30 60 180 1800 15 60"
#3p "users $PORT:CL:$PORT"; 3p "service"; 3p "external 0.0.0.0"; 3p "internal 0.0.0.0"; 3p "allow * * * 80-88,8080-8088 HTTP"; 3p "allow * * * 443,8443 HTTPS";
#3p "authcache user 60"; 3p "auth strong cache"; 3p "proxy -a -p$PORT -n";
cat > "/etc/3proxy/3proxy.cfg" <<END
daemon
nserver 8.8.8.8
nserver 8.8.4.4
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
users $PORT:CL:$PORT
service
#log /var/log/3proxy.log D
#logformat "- +_L%t.%. %N.%p %E %U %C:%c %R:%r %O %I %h %T"
#archiver rar rar a -df -inul %A %F
#rotate 30
external 0.0.0.0
internal 0.0.0.0
auth strong cache
#dnspr
#deny * * 127.0.0.1,192.168.1.1
allow * * * 80-88,8080-8088 HTTP
allow * * * 443,8443 HTTPS
proxy -a -p$PORT -n
#socks -p24018
flush
allow * * *
maxconn 20
flush
internal 127.0.0.1
allow 3APA3A 127.0.0.1
maxconn 3
pidfile /var/run/3proxy.pid
#admin
END
chmod 600 /etc/3proxy/3proxy.cfg; cat > /etc/init.d/3proxy << END 
#!/bin/sh
#
### BEGIN INIT INFO
# Provides: 3Proxy
# Required-Start: \$remote_fs $syslog
# Required-Stop: \$remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Initialize 3proxy server
# Description: starts 3proxy
### END INIT INFO
case "\$1" in
   start)
       echo Starting 3Proxy
       /etc/3proxy/3proxy /etc/3proxy/3proxy.cfg
       ;;
   stop)
       echo Stopping 3Proxy
       /usr/bin/killall 3proxy
       ;;
   restart|reload)
       echo Reloading 3Proxy
       /usr/bin/killall -s USR1 3proxy
       ;;
   *)
       echo Usage: \$0 "{start|stop|restart}"
       exit 1
esac
exit 0
END
chmod +x /etc/init.d/3proxy; update-rc.d 3proxy defaults; 
iptables -I INPUT -p tcp --dport $PORT -j ACCEPT; 
if [ -f /etc/iptables.up.rules ]; then iptables-save < /etc/iptables.up.rules; fi; 
service 3proxy start; echo; echo "  3Proxy installed & running on port $PORT"; 
echo "  Your Proxy authentication is: $PORT | $PORT"; echo "  You can add or delete & edit, \
enable or disable the authentication,"; echo "  Change the proxy type, add additional port a\
t /etc/3proxy/3proxy.cfg"; echo; read -p "  Back to main [enter]: "; cd ~; t
else read -p ") Uninstall 3Proxy? [y/n]: " -n 1 -r; if [[ $REPLY =~ ^[Yy]$ ]]; then echo; /usr/bin/killall 3proxy; 
rm -rf /etc/3proxy /usr/local/etc/3proxy /etc/init.d/3proxy /var/log/3proxy.log; 
netstat -tulpn; p_i "  Done unistalling 3Proxy"; s3; t; else echo "  Aborting!"; s3; t; fi; fi;; 

5)o_v;; 0)function t_ag { echo; read -p "  Test again? [y/n]: " -n 1 -r; echo; 
if [[ $REPLY =~ ^[Yy]$ ]]; then echo; t_as; ./sv --share; t_ag; else t; fi; }
function t_as { cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
swap=$( free -m | awk 'NR==4 {print $2}' )
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
clear; echo "CPU model : $cname"
echo "Number of cores : $cores"
echo "CPU frequency : $freq MHz"
echo "Total amount of ram : $tram MB"
echo "Total amount of swap : $swap MB"
free -m
echo "System uptime : $up"
echo; echo "  Download speed from : "
undip=$( wget -O /dev/null http://jaran.undip.ac.id/debian/dists/Debian7.5/main/Contents-i386.gz 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  UNDIP, Indonesia: $undip "
cachefly=$( wget -O /dev/null http://cachefly.cachefly.net/10mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  CacheFly: $cachefly "
coloatatl=$( wget -O /dev/null http://speed.atl.coloat.com/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  Coloat, Atlanta GA: $coloatatl "
linodejp=$( wget -O /dev/null http://speedtest.tokyo.linode.com/100MB-tokyo.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  Linode, Tokyo, JP: $linodejp "
slsg=$( wget -O /dev/null http://speedtest.sng01.softlayer.com/downloads/test10.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  Softlayer, Singapore: $slsg "
sldltx=$( wget -O /dev/null http://speedtest.dal05.softlayer.com/downloads/test10.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  Softlayer, Dallas, TX: $sldltx "
slam=$( wget -O /dev/null http://speedtest.ams01.softlayer.com/downloads/test10.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  Softlayer, Amsterdam, NL: $slam"
slwa=$( wget -O /dev/null http://speedtest.sea01.softlayer.com/downloads/test10.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  Softlayer, Seattle, WA: $slwa "
slsjc=$( wget -O /dev/null http://speedtest.sjc01.softlayer.com/downloads/test10.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  Softlayer, San Jose, CA: $slsjc "
slwdc=$( wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test10.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
echo "  Softlayer, Washington, DC: $slwdc "
io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' )
echo "I/O speed : $io"; }
if [ ! -e ~/sv ]; then echo; wget -O sv --no-check-certificate https://raw.github.com/sivel/speedtest-cli/master/speed\
test_cli.py; chmod 100 sv; fi; clear; p_i ""; t_as; ./sv --share; t_ag; t;; 

6)s_1;; 

S)function ts_q { if [ -e /etc/squid3/squid.conf ]; then read -p ") Uninstal Squid Proxy ? [y/n]: " -n 1 -r; 
if [[ $REPLY =~ ^[Yy]$ ]]; then apt-get remove --purge squid3\* -y; apt-get autoremove -y; rm -rf /etc/squid3/squid.conf; echo; echo " Done!"; s3; t; else echo ") Aborting!"; s3; t; fi; fi; 
clear
echo "  This script will set up a password protected,"
echo "  Elite proxy on your target server"
echo; echo "  Ctrl+c to cancel/exit!"
echo; echo; echo;
read -p "  Enter Port : " -r PO
read -p "  Enter User name : " -r UN
read -p "  Enter Password : " -r PA
clear
a="`netstat -i | cut -d' ' -f1 | grep eth0`";
b="`netstat -i | cut -d' ' -f1 | grep venet0:0`";
if [ "$a" == "eth0" ]; then
  ip="`/sbin/ifconfig eth0 | awk -F':| +' '/inet addr/{print $4}'`";
elif [ "$b" == "venet0:0" ]; then
  ip="`/sbin/ifconfig venet0:0 | awk -F':| +' '/inet addr/{print $4}'`";
fi
apt-get update
apt-get -y install apache2-utils
apt-get -y install squid3
rm /etc/squid3/squid.conf
cat > /etc/squid3/squid.conf <<END
acl ip1 myip $ip
tcp_outgoing_address $ip ip1
auth_param basic program /usr/lib/squid3/ncsa_auth /etc/squid3/squid_passwd
acl ncsa_users proxy_auth REQUIRED
http_access allow ncsa_users
acl manager proto cache_object
acl localhost src 127.0.0.1/32
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32
acl SSL_ports port 443
acl Safe_ports port 80        # http
acl Safe_ports port 21        # ftp
acl Safe_ports port 443        # https
acl Safe_ports port 1025-65535    # unregistered ports
acl Safe_ports port 280        # http-mgmt
acl Safe_ports port 488        # gss-http
acl Safe_ports port 591        # filemaker
acl Safe_ports port 777        # multiling http
acl CONNECT method CONNECT
http_access allow manager localhost
http_access deny manager
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access deny all
http_port $PO
hierarchy_stoplist cgi-bin ?
coredump_dir /var/spool/squid3
cache deny all
refresh_pattern ^ftp:        1440    20%    10080
refresh_pattern ^gopher:    1440    0%    1440
refresh_pattern -i (/cgi-bin/|\?) 0    0%    0
refresh_pattern .        0    20%    4320
icp_port 3130
forwarded_for off
request_header_access Allow allow all
request_header_access Authorization allow all
request_header_access Proxy-Authorization allow all
request_header_access Proxy-Authenticate allow all
request_header_access Cache-Control allow all
request_header_access Content-Encoding allow all
request_header_access Content-Length allow all
request_header_access Content-Type allow all
request_header_access Date allow all
request_header_access Expires allow all
request_header_access Host allow all
request_header_access If-Modified-Since allow all
request_header_access Last-Modified allow all
request_header_access Location allow all
request_header_access Pragma allow all
request_header_access Accept allow all
request_header_access Accept-Charset allow all
request_header_access Accept-Encoding allow all
request_header_access Accept-Language allow all
request_header_access Content-Language allow all
request_header_access Mime-Version allow all
request_header_access Retry-After allow all
request_header_access Title allow all
request_header_access Connection allow all
request_header_access Proxy-Connection allow all
request_header_access User-Agent allow all
request_header_access Cookie allow all
request_header_access All deny all
END
htpasswd -b -c /etc/squid3/squid_passwd $UN $PA
service squid3 restart
clear; echo; echo
echo "  Squid proxy server set up has been completed."
echo "  You can access your proxy server $ip on port $PO"
echo "  With User name: $UN "; echo "  Password: $PA"; s3; }
ts_q; t;;
esac; echo ") No option!"; s3; t done

