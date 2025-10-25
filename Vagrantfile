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

