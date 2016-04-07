function create_gp_vm {

apt-get --yes --force-yes install virtinst
qemu-img create -f qcow2 /var/lib/libvirt/images/gp.qcow2 11G
cat << EOF > /etc/libvirt/qemu/gp.xml
<domain type='kvm' id='6522'>
  <name>gp</name>
  <uuid>ccf363ff-a729-41f3-b9fa-b6d6acace318</uuid>
  <memory unit='KiB'>1572864</memory>
  <currentMemory unit='KiB'>1572864</currentMemory>
  <vcpu placement='static'>2</vcpu>
  <resource>
    <partition>/machine</partition>
  </resource>
  <os>
    <type>hvm</type>
    <boot dev='network'/>
    <boot dev='hd'/>
    <bios rebootTimeout='5000'/>
  </os>
  <cpu mode='host-passthrough'>
  </cpu>
  <clock offset='utc'>
    <timer name='rtc' tickpolicy='catchup' track='wall'>
      <catchup threshold='123' slew='120' limit='10000'/>
    </timer>
    <timer name='pit' tickpolicy='delay'/>
    <timer name='hpet' present='no'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/kvm-spice</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='unsafe'/>
      <source file='/var/lib/libvirt/images/gp.qcow2'/>
      <target dev='vda' bus='virtio'/>
      <serial>1627ff80b8144c21b077c47372130d7a</serial>
      <alias name='virtio-disk0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </disk>
    <interface type='bridge'>
      <source bridge='baremetal-br'/>
      <mac address='00:16:3e:49:1d:11'/>
    </interface>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <graphics type='vnc' port='5943' autoport='yes' listen='0.0.0.0'>
      <listen type='address' address='0.0.0.0'/>
    </graphics>
    <video>
      <model type='vga' vram='9216' heads='1'/>
      <alias name='video0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
    </video>
    <memballoon model='virtio'>
      <alias name='balloon0'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x06' function='0x0'/>
    </memballoon>
  </devices>
</domain>
EOF

virsh define /etc/libvirt/qemu/gp.xml

}

function clone_vms {
  for i in {1..120}; do virt-clone -o gp -n gp-clone-$i --auto-clone; done
}

create_gp_vm
clone_vms
