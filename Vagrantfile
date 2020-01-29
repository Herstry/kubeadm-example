# -*- mode: ruby -*-
# vi: set ft=ruby :

hosts = {
	"master" => "192.168.1.101",
  "node01" => "192.168.1.102",
}

Vagrant.configure("2") do |config|
  hosts.each do |name, ip|
    config.vm.define name do |machine|
      machine.vm.box = "bento/ubuntu-16.04"
      machine.vm.hostname = name
      machine.vm.network :private_network, ip: ip
      machine.vm.provider "virtualbox" do |v|
          v.name = name
          v.customize ["modifyvm", :id, "--cpus", 3]
          v.customize ["modifyvm", :id, "--memory", 6048]
      end

      config.vm.provision "shell" do |s|
        s.path = "setup.sh"
      end
    end
  end
end
