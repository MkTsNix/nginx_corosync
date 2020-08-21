# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"

MACHINES = {
  :node1 => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.81',
    :disks => {
        :sata1 => {
            :dfile => home + '/VirtualBox VMs/corosync/sata11.vdi',
            :size => 256,
            :port => 1
        },
    },
  },

  :node2 => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.82',
    :disks => {
        :sata1 => {
            :dfile => home + '/VirtualBox VMs/corosync/sata21.vdi',
            :size => 256,
            :port => 1
        },
    },
  },
  :node3 => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.83',
    :disks => {
        :sata1 => {
            :dfile => home + '/VirtualBox VMs/corosync/sata31.vdi',
            :size => 256,
            :port => 1
        },
    },
  },
  :nfs1 => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.84',
    :disks => {
        :sata1 => {
            :dfile => home + '/VirtualBox VMs/corosync/sata41.vdi',
            :size => 1024,
            :port => 1
        },
    },
  },
}

Vagrant.configure("2") do |config|

    config.vm.box_version = "1804.02"
    MACHINES.each do |boxname, boxconfig|
  
        config.vm.define boxname do |box|
  
            box.vm.box = boxconfig[:box_name]
            box.vm.host_name = boxname.to_s
  
            #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset
  
            box.vm.network "private_network", ip: boxconfig[:ip_addr]
  
            box.vm.provider :virtualbox do |vb|
                    vb.customize ["modifyvm", :id, "--memory", "256"]
                    needsController = false
            boxconfig[:disks].each do |dname, dconf|
                unless File.exist?(dconf[:dfile])
                  vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
                                  needsController =  true
                            end
  
            end
                    if needsController == true
                       vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
                       boxconfig[:disks].each do |dname, dconf|
                           vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                       end
                    end
            end
  
          box.vm.provision "shell", inline: <<-SHELL
            mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
            sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
            systemctl restart sshd
          SHELL

  
        end
    end
  end
  
