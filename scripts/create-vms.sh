parted -s /dev/sda mkpart primary ext4 20940800s 146485247s
mkfs.ext4 /dev/sda4 

mkdir /var/lib/libvirt/images2
mount /dev/sda4 /var/lib/libvirt/images2/
mv /var/lib/libvirt/images/gp1.img /var/lib/libvirt/images2/gp1.img
sed -i 's/images\//images2\//g' /etc/libvirt/qemu/gp1.xml
virsh define /etc/libvirt/qemu/gp1.xml

for i in {1..30}; do virt-clone -o gp1 -n gp1-clone-$i --auto-clone; done
