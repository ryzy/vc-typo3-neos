Vagrant.require_plugin "vagrant-vbguest"
Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  config.vm.hostname = "vc-typo3"
  config.ssh.username = 'vagrant'
  
  config.vm.box = "opscode-centos-6.5"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"
  
  config.vm.boot_timeout = 120
  config.vm.network :private_network, ip: '192.168.66.6'
  
  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "8"]
  end
  
  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    # override.vm.box = 'digital_ocean'
    # override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"
    provider.client_id = 'xxxx'
    provider.api_key = 'xxxx'
    provider.region = 'Amsterdam 2'
    provider.image = 'CentOS 6.4 x64'
    provider.size = '2GB' # and 2vCPU
  end
  
  config.vbguest.auto_update = true  
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  
  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      "recipe[vc-typo3::default]"
    ]
  end
end
