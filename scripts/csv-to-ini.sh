CSV_FILE=${CSV_FILE:-'/root/Ironic/baremetal_servers_ipmi.txt'}
INI_FILE=${INI_FILE:-'/root/hardware-nodes.ini'}

for line in  $(cat $CSV_FILE); do
  name=$(echo $line | awk -F ',' '{print $1}')
  ipmi_address=$(echo $line | awk -F ',' '{print $2}')
  ipmi_password=$(echo $line | awk -F ',' '{print $3}')
  mac_address=$(echo $line | awk -F ',' '{print $4}')


  echo "[$name]" >> $INI_FILE
  echo "mac_address=$mac_address" >> $INI_FILE
  echo "ipmi_address=$ipmi_address" >> $INI_FILE
  echo "ipmi_password=$ipmi_password" >> $INI_FILE
  echo "" >> $INI_FILE

done
