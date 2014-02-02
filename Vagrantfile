Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  config.ssh.username = 'vagrant'
  config.vm.boot_timeout = 120
  
  config.vm.hostname = "vc-typo3-neos"
  
  # Default box for Virtualbox provider
 config.vm.box = "opscode-centos-6.5"
 config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"
  
  config.vm.provider :virtualbox do |vb, override|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    override.vm.network :private_network, ip: '192.168.88.8'
    override.vbguest.auto_update = true
  end
  
  config.vm.provider :parallels do |prl, override|
    # prl.name = "vc-parallels"
    prl.customize ["set", :id, "--memsize", "1024"]
    prl.customize ["set", :id, "--cpus", "4"]
    prl.customize ["set", :id, "--adaptive-hypervisor", "on"]
    override.vm.box = 'centos-6.5-x86_64-minimal'
    override.vm.box_url = "https://drive.google.com/file/d/0B1zkUS5UKRCscktsV01uSzk1WEU/edit?usp=sharing"
  end
  
  config.vm.provider :digital_ocean do |doc, override|
    doc.client_id = ENV['DIGITAL_OCEAN_CLIENT_ID']
    doc.api_key = ENV['DIGITAL_OCEAN_API_KEY']
    doc.region = 'Amsterdam 2'
    doc.image = 'CentOS 6.4 x64'
    doc.size = '2GB' # and 2vCPU
    override.ssh.private_key_path = '~/.ssh/id_rsa'
  end
  
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true
  
  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      'recipe[lemp-server::default]',
      'recipe[typo3-neos::default]'
    ]
  end
end
