function install_rally {
  sudo mkdir /var/lib/rally_container
  sudo cp ../scale-templates/* /var/lib/rally_container/
  
  sudo chown 65500 /var/lib/rally_container

  sudo iptables -I FORWARD -s 172.17.0.0/24 -j ACCEPT
  sudo iptables -t nat -I POSTROUTING -s 172.17.0.0/24 -j MASQUERADE
}

install_rally
docker run -it -v /var/lib/rally_container:/home/rally rallyforge/rally
