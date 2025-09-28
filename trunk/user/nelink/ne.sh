#!/bin/sh

nelink_keyg=$(nvram get nelink_keyg)
echo $nelink_keyg
nelink_ip=$(nvram get nelink_ip)
echo $nelink_ip
nelink_inlan1=$(nvram get nelink_inlan1)
echo $nelink_inlan1
nelink_xuip1=$(nvram get nelink_xuip1)
echo $nelink_xuip1
lan_ipaddr=$(nvram get lan_ipaddr) 
echo $lan_ipaddr
nelink_log=$(nvram get nelink_log)
echo $nelink_log
nelink_log2=$(nvram get nelink_log2)
echo $nelink_log2
nelink_log3=$(nvram get nelink_log3)
echo $nelink_log3

start_ne() {
	[ "$et_enable" = "0" ] && return 1
	logg "正在启动nelink"
  	if [ -z "$ne_cli" ] ; then
		ne_core=/tmp/var/nelink
  		nvram set nelink_bin=$ne_cli
    	fi
	necmd="/usr/bin/netlink --tun-name nehxkj  -g $nelink_keyg -l 10.26.2.$nelink_ip/24 -p $nelink_log --api-addr $lan_ipaddr:23336 >/tmp/nelink.log 2>&1"
	echo "$necmd" >/tmp/nelink.CMD 
	logg "运行${necmd}"
	eval "$necmd" &
	sleep 4
	if [ ! -z "`pidof netlink`" ] ; then
 		mem=$(cat /proc/$(pidof netlink)/status | grep -w VmRSS | awk '{printf "%.1f MB", $2/1024}')
   		necpu="$(top -b -n1 | grep -E "$(pidof netlink)" 2>/dev/null| grep -v grep | awk '{for (i=1;i<=NF;i++) {if ($i ~ /netlink/) break; else cpu=i}} END {print $cpu}')"
		logg "运行成功！"
  		logg "内存占用 ${mem} CPU占用 ${necpu}%"
  		et_restart o
		echo `date +%s` > /tmp/nelink_time
		et_rules
	else
		logg "运行失败, 注意检查${ne_cli}是否下载完整,10 秒后自动尝试重新启动"
  		sleep 10
  		et_restart x
	fi
	return 0

route add -net $nelink_inlan1/24 gw $nelink_xuip1
$nelink_log
$nelink_log2
$nelink_log3

if [ ! -z "`pidof netlink`" ] ; then
logger -t "netlink" "启动成功"
#放行netlink防火墙
iptables -I INPUT -i nehxkj -j ACCEPT
iptables -I FORWARD -i nehxkj -o nehxkj -j ACCEPT
iptables -I FORWARD -i nehxkj -j ACCEPT
iptables -t nat -I POSTROUTING -o nehxkj -j MASQUERADE

#开启arp
ifconfig nehxkj arp
else
logger -t "netlink" "启动失败"
fi
}

stop_ne() {
	logg  "正在关闭..."
	sed -Ei '/【nelink】|^$/d' /tmp/script/_opt_script_check
	scriptname=$(basename $0)
	if [ -z "$et_tunname" ] ; then
		tunname="nehxkj"
	else
		tunname="${ne_tunname}"
	fi
	killall netlink
	killall -9 netlink
	if [ ! -z "$ne_ports" ] ; then
		ne_portss=$(echo $ne_ports | tr -d '\r')
		for et_port in $ne_portss ; do
			[ -z "$ne_port" ] && continue
iptables -D INPUT -i nehxkj -j ACCEPT 2>/dev/null
iptables -D FORWARD -i nehxkj -o nehxkj -j ACCEPT 2>/dev/null
iptables -D FORWARD -i nehxkj -j ACCEPT 2>/dev/null
iptables -t nat -D POSTROUTING -o nehxkj -j MASQUERADE 2>/dev/null
		done	
	fi
	[ -z "`pidof netlink`" ] && [ -z "`pidof netlink`" ] && logg "进程已关闭!"
	if [ ! -z "$scriptname" ] ; then
		eval $(ps -w | grep "$scriptname" | grep -v $$ | grep -v grep | awk '{print "kill "$1";";}')
		eval $(ps -w | grep "$scriptname" | grep -v $$ | grep -v grep | awk '{print "kill -9 "$1";";}')
	fi
}

ne_error="错误：${ne_cli} 未运行，请运行成功后执行此操作！"
ne_process=$(pidof netlink)
nepath=$(dirname "$ne_cli")
cmdfile="/tmp/nelink.log"

start)
	start_ne &
	;;
stop)
	stop_ne
	;;
restart)
	stop_ne
	start_ne &
	;;
status)
	status
	;;
*)
	echo "check"
	#exit 0
	;;
esac
