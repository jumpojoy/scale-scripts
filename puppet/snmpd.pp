# Install razorsedge-snmp
# puppet module install razorsedge-snmp

class { 'snmp':
  agentaddress => [ 'udp:161', ],
  ro_community => 'public',
  ro_network   => ['172.18.170.44/32', '10.14.0.0/24']
}
