Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-omnibus"

Vagrant.configure("2") do |config|
  config.ssh.username = 'vagrant'
  config.vm.boot_timeout = 120
  
  config.vm.hostname = 'vc-typo3-neos'
  
  # In global config provide just dummy box - all providers use their own boxes and needs to be overriden
  config.vm.box = 'dummy'
  config.vm.box_url = 'https://github.com/ryzy/vc-lemp-server/blob/master/dummy.box?raw=true'
  
  config.vm.provider :virtualbox do |vb, override|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ["modifyvm", :id, "--cpus", "4"]
    override.vm.network :private_network, ip: '192.168.88.8'
    override.vbguest.auto_update = true
    override.vm.box = 'opscode-centos-6.5'
    override.vm.box_url = 'http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box'
  end
  
  config.vm.provider :parallels do |prl, override|
    # prl.name = "vc-parallels"
    prl.customize ["set", :id, "--memsize", "1024"]
    prl.customize ["set", :id, "--cpus", "4"]
    prl.customize ["set", :id, "--adaptive-hypervisor", "on"]
    override.vm.box = 'centos-6.5-x86_64-minimal'
    override.vm.box_url = 'https://drive.google.com/file/d/0B1zkUS5UKRCscktsV01uSzk1WEU/edit?usp=sharing'
  end
  
  config.vm.provider :digital_ocean do |doc, override|
    doc.client_id                 = ENV['DIGITAL_OCEAN_CLIENT_ID']
    doc.api_key                   = ENV['DIGITAL_OCEAN_API_KEY']
    doc.region                    = 'Amsterdam 2'
    doc.image                     = 'CentOS 6.4 x64'
    doc.size                      = '2GB' # and 2vCPU
    override.ssh.private_key_path = '~/.ssh/id_rsa'
  end
  
  config.vm.provider :rackspace do |rs, override|
    # rs.server_name                = 'default'
    rs.username                   = ENV['RACKSPACE_CLIENT_ID']
    rs.api_key                    = ENV['RACKSPACE_API_KEY']
    rs.rackspace_region           = :lon
    rs.flavor                     = /2 GB Performance/
    rs.image                      = 'CentOS 6.5'
    rs.disk_config                = 'AUTO'
    rs.public_key_path            = '~/.ssh/id_rsa.pub'
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.ssh.username         = 'root'
    override.ssh.pty              = true
  end
  
  config.omnibus.chef_version = '11.8.0'
  config.berkshelf.enabled = true
  
  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      'recipe[lemp-server::default]',
      'recipe[typo3-neos::default]'
    ]
  end
end
