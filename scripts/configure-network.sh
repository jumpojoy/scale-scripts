BAREMETAL_NETWORK=${BAREMETAL_NETWORK:-'192.168.16.0/20'}

function create_bridge {

apt-get --yes --force-yes install bridge-utils

if ! `ip route |grep default |grep -q baremetal-br`; then

 local ext_interface
 ext_interface=$(ip route |grep default | awk '{print $5}')

 sed s/dhcp/manual/ -i /etc/network/interfaces.d/${ext_interface}.cfg

echo " \
# Bridge setup
iface baremetal-br inet dhcp
  bridge_ports $ext_interface
  bridge_stp off
" > /etc/network/interfaces.d/baremetal-br.cfg

  ifconfig $ext_interface down && ifconfig $ext_interface up && ifup baremetal-br
fi
}

function disable_unused_interfaces {
for i in $(grep -v  manual  /etc/network/interfaces.d/* -l |grep -v baremetal | awk -F '/' '{print $5}' |awk -F '.' '{print $1}'); do
  sed 's/dhcp/manual/' -i /etc/network/interfaces.d/$i.cfg
  ifdown $i && ifup $i
done
}

function block_external_dhcp {
  iptables -F
  iptables -I FORWARD ! -s $BAREMETAL_NETWORK -p udp -m multiport --dports 68 -j DROP
}

create_bridge
disable_unused_interfaces
block_external_dhcp
