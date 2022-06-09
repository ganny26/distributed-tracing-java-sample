Vagrant.configure("2") do |config|
  config.vm.box = "mattburnett/fedora-35-m1-arm64"
  config.vm.provider "parallels" do |v|
    v.memory = "4096"
    v.cpus = 2
  end
  config.vm.synced_folder ".", "/vagrant", owner: "vagrant",
                                           group: "vagrant"
  config.vm.network "forwarded_port", guest: 8761, host: 8761
  config.vm.network "forwarded_port", guest: 9090, host: 9099
  config.vm.network "forwarded_port", guest: 8081, host: 8081
  config.vm.network "forwarded_port", guest: 8082, host: 8082
  config.vm.network "forwarded_port", guest: 8083, host: 8083
end
