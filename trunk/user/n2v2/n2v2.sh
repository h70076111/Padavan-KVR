#!/bin/sh

n2v2_enable=$(nvram get n2v2_enable)
n2v2_keyg=$(nvram get n2v2_keyg)
n2v2_ip=$(nvram get n2v2_ip)
n2v2_inlan1=$(nvram get n2v2_inlan1)
n2v2_xuip1=$(nvram get n2v2_xuip1)
lan_ipaddr=$(nvram get lan_ipaddr) 
n2v2_log=$(nvram get n2v2_log)
n2v2_log2=$(nvram get n2v2_log2)
n2v2_log3=$(nvram get n2v2_log3)


start_n2v() {
iptables -D INPUT -i n2v2_tun -j ACCEPT 2>/dev/null
iptables -D FORWARD -i n2v2_tun -o n2v2_tun -j ACCEPT 2>/dev/null
iptables -D FORWARD -i n2v2_tun -j ACCEPT 2>/dev/null
iptables -t nat -D POSTROUTING -o n2v2_tun -j MASQUERADE 2>/dev/null
killall n2v2
killall -9 n2v2
sleep 3

#清除vnt的虚拟网卡
ifconfig n2v2_tun down && ip tuntap del n2v2_tun mode tun

n2cmd="/usr/bin/n2v2 -c $n2v2_keyg -a $n2v2_ip -d n2v2_tun -l $n2v2_log"
echo "$n2cmd" >/tmp/n2v2.CMD 
logger -t "【宏兴智能组网】" "运行${n2cmd}"
eval "$n2cmd" &
sleep 5
n20=n2v2_tun
if [ ! -z "`pidof edge2`" ] ; then
 logger -t "n2v2" "启动成功"

	rulesnum=`nvram get n2v2_routenum_x`
	for i in $(seq 1 $routenum)
	do
		j=`expr $i - 1`
		n2v2_ip=`nvram get n2v2_ip_x$j`
		n2v2_route=`nvram get n2v2_route_x$j`
		if [ "$1" = "add" ]; then
				ip route add $n2v2_route via $n2v2_ip dev $n20
				echo "$n20"
			fi
		else
			ip route del $n2v2_route via $n2v2_ip dev $n20
		fi
	done

#放行vnt防火墙
iptables -I INPUT -i n2v2_tun -j ACCEPT
iptables -I FORWARD -i n2v2_tun -o vnt-tun -j ACCEPT
iptables -I FORWARD -i n2v2_tun -j ACCEPT
iptables -t nat -I POSTROUTING -o n2v2_tun -j MASQUERADE
#开启arp
ifconfig n2v2_tun arp
else
logger -t "n2v2" "启动失败"
fi

}

stop_n2v() {
 	
	iptables -D INPUT -i n2v2_tun -j ACCEPT 2>/dev/null
	iptables -D FORWARD -i n2v2_tun -o n2v2_tun -j ACCEPT 2>/dev/null
	iptables -D FORWARD -i n2v2_tun -j ACCEPT 2>/dev/null
	iptables -t nat -D POSTROUTING -o n2v2_tun -j MASQUERADE 2>/dev/null
	
	n2v2_process=$(pidof n2v2)
	if [ -n "$n2v2_process" ]; then
		logger -t "组网" "关闭进程..."
		killall n2v2 >/dev/null 2>&1
		kill -9 "$n2v2_process" >/dev/null 2>&1
	fi
}

case $1 in
start)
	start_n2v
	;;
stop)
	stop_n2v &
	;;
*)
	echo "check"
	#exit 0
	;;
esac
