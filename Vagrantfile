Vagrant.require_version '>= 1.6.2'

Vagrant.configure("2") do |config|
  config.ssh.username = 'vagrant'
  config.ssh.private_key_path = [
    '~/.ssh/id_rsa',
    '~/.vagrant.d/insecure_private_key'
  ]
  config.vm.hostname = 'vc-typo3-neos'
  
  # In global config provide just dummy box - all providers use their own boxes and needs to be overriden
  config.vm.box = 'dummy'
  
  config.vm.provider :virtualbox do |vb, override|
    override.vm.box = 'chef/centos-6.5'
    override.vm.network :private_network, ip: '192.168.88.8'
#    override.vbguest.auto_update = true
    vb.gui = false
    vb.customize ['modifyvm', :id, '--memory', '1024']
    vb.customize ['modifyvm', :id, '--cpus', '4']
  end
  
  config.vm.provider :parallels do |prl, override|
    override.vm.box = 'parallels/centos-6.5'
    prl.customize ['set', :id, '--memsize', '1024']
    prl.customize ['set', :id, '--cpus', '4']
    prl.customize ['set', :id, '--adaptive-hypervisor', 'on']
  end
  
  config.vm.provider :digital_ocean do |doc, override|
    doc.client_id                 = ENV['DIGITAL_OCEAN_CLIENT_ID']
    doc.api_key                   = ENV['DIGITAL_OCEAN_API_KEY']
    doc.region                    = 'Amsterdam 2'
    doc.image                     = 'CentOS 6.5 x64'
    doc.size                      = '2GB' # and 2vCPU
  end
  
  config.vm.provider :rackspace do |rs, override|
    override.ssh.username         = 'root'
    override.ssh.pty              = true
    #rs.server_name                = 'default'
    rs.username                   = ENV['RACKSPACE_CLIENT_ID']
    rs.api_key                    = ENV['RACKSPACE_API_KEY']
    rs.rackspace_region           = :lon
    rs.flavor                     = /1 GB Performance/
    rs.image                      = 'CentOS 6.5'
    rs.disk_config                = 'AUTO'
    rs.public_key_path            = '~/.ssh/id_rsa.pub'
  end
  
  config.omnibus.chef_version = '11.10.0'
  config.berkshelf.enabled = true
  
  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      'recipe[lemp-server]',
      'recipe[typo3-neos]'
    ]
  end
end
