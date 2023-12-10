# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"

disk_controller = 'IDE'

MACHINES = {
    :zfs => {
            :box_name => "centos/7",
            :box_version => "2004.01",
        :disks => {
            :sata1 => {
                :dfile => './sata1_zfs.vdi',
                :size => 512,
                :port => 1
            },
            :sata2 => {
                :dfile => './sata2_zfs.vdi',
                :size => 512,
                :port => 2
            },
            :sata3 => {
                :dfile => './sata3_zfs.vdi',
                :size => 512,
                :port => 3
            },
            :sata4 => {
                :dfile => './sata4_zfs.vdi',
                :size => 512,
                :port => 4
            },
            :sata5 => {
                :dfile => './sata5_zfs.vdi',
                :size => 512,
                :port => 5
            },
            :sata6 => {
                :dfile => './sata6_zfs.vdi',
                :size => 512,
                :port => 6
            },
            :sata7 => {
                :dfile => './sata7_zfs.vdi',
                :size => 512,
                :port => 7
            },
            :sata8 => {
                :dfile => './sata8_zfs.vdi',
                :size => 512,
                :port => 8
            },
        }
    },
}

Vagrant.configure("2") do |config|

    MACHINES.each do |boxname, boxconfig|

        config.vm.define boxname do |box|

            box.vm.box = boxconfig[:box_name]
            box.vm.box_version = boxconfig[:box_version]

            box.vm.host_name = "zfs"

            box.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", "1024"]
                needsController = false
            boxconfig[:disks].each do |dname, dconf|
                unless File.exist?(dconf[:dfile])
                vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
            needsController = true
            end
        end
            if needsController == true
                vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
                boxconfig[:disks].each do |dname, dconf|
                vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                end
            end
        end
        box.vm.provision "shell", inline: <<-SHELL
                yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_9.noarch.rpm
                rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
                yum install -y epel-release kernel-devel dkms
                yum-config-manager --disable zfs
                yum-config-manager --enable zfs-kmod
                yum install -y zfs
                modprobe zfs
                yum install -y wget
                wget -P /home/vagrant/ https://raw.githubusercontent.com/olegizt/DZ4/main/dz_zfs.sh
                chmod +x /home/vagrant/dz_zfs.sh
            SHELL
        end
    end
end