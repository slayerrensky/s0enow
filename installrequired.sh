#!/bin/bash

#sudo apt-get update
#apt-get install -y vim apache2 mysql-server wvdial rsync rrdtool 

# wvdial einrichten
#cp ./config/wvdial.conf /etc/
#sudo echo " " >> /etc/network/interfaces
#sudo echo "auto ppp0" >> /etc/network/interfaces
#sudo echo "iface ppp0 inet wvdial" >> /etc/network/interfaces
#sudo echo "provider netzclub" >> /etc/network/interfaces

#1Wire aktivieren über GPIO
#modprobe w1-gpio
#modprobe w1-therm
#echo "w1-gpio" >>/etc/modules
#echo "w1-therm" >>/etc/modules
#echo "i2c-dev" >>/etc/modules
#echo "ds2482" >>/etc/modules

# Links für Apache erstellen
#mkdir -p /var/www/data-log
#iln -s /tmp/temp24.png /var/www/data-log/temp24.png
#ln -s /tmp/lastValue.txt /var/www/data-log/lastValue.txt
#ln -s /home/pi/data-log/data/ /var/www/data-log/data

# SSH Key erstellen und kopieren
#ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
#echo "Sie werden jetzt aufgeforder das Passwort für den entfernten Server anzugeben."
echo $(cat ~/.ssh/id_rsa.pub) | ssh pi@123.123.123.123 'cat >> ~/.ssh/authorized_keys'
#cp ./config/sshconfig ~/.ssh/config


