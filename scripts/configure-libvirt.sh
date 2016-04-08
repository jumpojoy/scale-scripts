function configure_libvirt {
cat << EOF > /etc/default/libvirtd
start_libvirtd="yes"
libvirtd_opts="-d -l"
EOF

cat << EOF > /etc/libvirt/libvirtd.conf
listen_tls = 0
listen_tcp = 1
tcp_port = "16509"
listen_addr = "0.0.0.0"
auth_tcp = "none"
EOF

service libvirtd restart
}

configure_libvirt
