# DNS_guided_practice

This is the guided practice of DNS

## Memoria de la practica

-Crear carpeta config, vagrantifle, provision y gitignore

El vagrantfile:

```ruby

    # -*- mode: ruby -*-
    # vi: set ft=ruby :


    Vagrant.configure("2") do |config|
    config.vm.define "dns-server" do |dns|
        dns.vm.box = "debian/bullseye64"
        dns.vm.hostname = "dns-server"
        dns.vm.network "private_network", ip: "192.168.56.10"
        dns.vm.provision "shell", path: "provision.sh"
    end
    end

```

El provision:

```bash

    #!/bin/bash

    set -e

    apt-get update
    apt-get install -y bind9 bind9utils bind9-doc dnsutils

    #Copiar ficheros de config desde /vagrant/config a su sitio en la VM (dejo el true de momento para que no falle en el primer vagrat up)

    cp /vagrant/config/* /etc/bind/ || true

    systemctl restart bind9

```
### Archivos de configuracion del dns



```bash
    vagrant ssh dns-server
    sudo systemctl status bind9
    cd /etc/bind
    cp named.conf.options named.conf.options.backup
    sudo nano named.conf.options

```

Archivo named.conf.options:

```conf

    acl confiables {
        192.168.56.0/24;
    };

    options {
            directory "/var/cache/bind";
            allow-transfer { none; };
            listen-on port 53 { 192.168.56.10; };
            recursion yes;
            allow-recursion { confiables; };
            dnssec-validation yes;
            // listen-on-v6 { any; };
    };


```

```bash

    sudo named-checkconf /etc/bind/named.conf.options
    sudo nano named.conf.local

```

```conf

   zone "dani.test" {
    type master;
    file "/var/lib/bind/dani.test.dns";
    };

    zone "56.168.192.in-addr.arpa" {
        type master;
        file "/var/lib/bind/dani.test.rev";
    };
 

```

```bash

    sudo named-checkconf named.conf.local
    sudo nano /var/lib/bind/dani.test.dns

```
```conf

    $TTL 86400
    @   IN  SOA debian.dani.test. admin.dani.test. (
                    20251025    ; Serial (formato YYYYMMDDnn)
                    3600
                    1800
                    604800
                    86400 )
    ;
    @       IN  NS      debian.dani.test.
    debian.dani.test. IN  A 192.168.56.10

```

```bash

    sudo named-checkzone dani.test /var/lib/bind/dani.test.dns
    sudo nano /var/lib/bind/dani.test.rev

```

```conf

   $TTL 86400
    @   IN  SOA debian.dani.test. admin.dani.test. (
                    20251025
                    3600
                    1800
                    604800
                    86400 )
    ;
    @       IN  NS      debian.dani.test.
    10      IN  PTR     debian.dani.test.

```
```bash

    sudo named-checkzone 56.168.192.in-addr.arpa /var/lib/bind/dani.test.rev
    sudo systemctl restart bind9
    sudo systemctl status bind9
    sudo cp /etc/bind/named.conf.options /vagrant/config/
    sudo cp /etc/bind/named.conf.local /vagrant/config/
    sudo cp /var/lib/bind/dani.test.dns /vagrant/config/
    sudo cp /var/lib/bind/dani.test.rev /vagrant/config/


```

Hacemos logout y en mi maquina:

```bash

    dig @192.168.56.10 debian.dani.test
    dig @192.168.56.10 debian.dani.test +trace +additional +stats

    nslookup debian.dani.test 192.168.56.10


```

Todo ha funcionado bien








