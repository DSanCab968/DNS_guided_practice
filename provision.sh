#!/bin/bash

set -e

apt-get update
apt-get install -y bind9 bind9utils bind9-doc dnsutils

#Copiar ficheros de config desde /vagrant/config a su sitio en la VM (dejo el true de momento para que no falle en el primer vagrat up)

cp /vagrant/config/* /etc/bind/ || true

systemctl restart bind9
