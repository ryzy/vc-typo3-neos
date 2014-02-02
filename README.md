# TYPO3 Neos with Vagrant/Chef

Complete environment for TYPO3 Neos using Vagrant + Chef + Berkshelf provisioning.

#### Features

To make sure this VM setup suits TYPO3 Flow/Neos development, the following are included in the setup:

* machine is CentOS 6.5 based

* Vagrant provisioning is done by [Chef](http://www.getchef.com/chef/)(solo) + [Berkshelf](http://berkshelf.com/)

* Vagrant configuration for VirtualBox / Parallels Desktop / [DigitalOcean.com](https://www.digitalocean.com/?refcode=58af8bab822f) providers

* LEMP stack (Linux/Nginx/MySQL/PHP) environment installed/configured using [ryzy/vc-lemp-server](https://github.com/ryzy/vc-lemp-server) cookbook:
  * MySQL 5.5 (+tuning)
  * Nginx (latest 1.4.x)
  * PHP (latest 5.5.x)
  * phpMyAdmin installed
	
* TYPO3 Neos installed (into /var/www/neos)
	* vhosts `neos`, `neos.dev` and `neos.test` available (configured with FLOW_CONTEXT set to Production, Development, Testing respectively)
	* user `admin` with password `password` already added to TYPO3 Neos
	
## Requirements

1. Install [Vagrant](http://www.vagrantup.com/)
2. Depends on your chosen Vagrant provider: install VirtualBox **OR** Parallels Desktop **OR** set up an account on [DigitalOcean.com](https://www.digitalocean.com/?refcode=58af8bab822f)
3. Make sure you have Ruby 1.9.x or 2.x installed.
4. Make sure you have Ruby Bundler installed:
  ```[sudo] gem install bundler```

## Usage

* **Install** required gems (specified in Gemfile) and vagrant plugins:

  ```bash
  bundle install
  vagrant plugin install vagrant-berkshelf
  vagrant plugin install vagrant-omnibus
  ```

  * If you're using VirtualBox provider, also install [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) plugin:
    ```
    vagrant plugin install vagrant-vbguest
    ```

* **Run** `vagrant up` to kick off your machine:
  ```bash
  vagrant up
  # or, if you want to use provider different than VirtualBox:
  vagrant up --provider=CHOSEN_PROVIDER
  ```

  Sometimes `vagrant up` **fails due to temporary reasons** - just try again with `vagrant provision` (to just re-provision the server) or `vagrant reload --provision` (to do reboot and then re-provision).

* **Go to VM_IP_ADDRESS** to see VM's default vhost. You'll see there phpinfo() and link to phpMyAdmin.
  * Note: if you're not sure about the VM IP address, just log in there using `vagrant ssh` and run `ifconfig`. 

* **Map `neos`, `neos.dev`, `neos.test` in your `hosts` file** to your VM_IP_ADDRESS address, e.g.
  ```bash
  192.168.66.6 neos neos.dev neos.test
  ```

* **Go to [neos.dev](http://neos.dev/)** to see TYPO3 Neos page.

* **Start happy coding!**

  * You'll probably download/upload files via SFTP, mapping your local project paths to the remote paths. Optionally you might mount whole `/var/www` to your local filesystem - then read the point below **Mount VM's `/var/www` to your filesystem**.

### Users / Passwords, security

All passwords (apart of the `root`) are defined in attributes/default.rb:

* **ssh:** user: root, passw: `vagrant`
* **ssh:** user: vagrant, passw: `vagrant`
* **mysql:** user: root, passw: `password`

You can connect to MySQL from outside VM machine as user _root_ is added with '%' host. And there's no iptables running, so no firewall setup.


## Provider: Parallels Desktop

Why bother, if VirtualBox is so cool, free and there's plenty of ready to use image boxes? Well, look up some [benchmarks](http://www.macobserver.com/tmo/article/benchmarking-parallels-fusion-and-virtualbox-against-boot-camp) - I'm sure you'll appreciate 3-digit % difference in performance (e.g. during my tests on the same machine, Neos back-end loaded in 800..1000ms (VB) vs 300..500ms (PD9). Values for Development environment).

#### Usage

* You will need Parallels Desktop compatible box. You'll also need to install [vagrant-parallels](https://github.com/Parallels/vagrant-parallels) provider.
  * You can use my box (link configured in Vagrantfile in :parallels provider section) or build your own using [veewee](https://github.com/jedi4ever/veewee) or [packer.io](http://www.packer.io/). You can use my CentOS 6 template for veewee from [here](https://github.com/ryzy/veewee-centos6).
  * Note: prepared by me Parallels box is on Google Drive, which forbids directs downloads and uses redirests - Vagrant can't handle it and you have to download it manually (via browser) and add `vagrant box add centos-6.5-x86_64-minimal ~/Downloads/centos-6.5-x86_64-minimal.box`. You'll find the link in Vagrantfile, in `vm.box_url` line in :parallels config section.
* `vagrant plugin install vagrant-parallels`
* `vagrant up --provider=parallels`
* Optionally, add line with `export VAGRANT_DEFAULT_PROVIDER=parallels` to your .bash_profile to use this provider as default.

## Provider: DigitalOcean

This part describes how to deploy this setup to [DigitalOcean.com](https://www.digitalocean.com/?refcode=58af8bab822f). After `vagrant up --provider=digital_ocean` you'll have up & running droplet there, provisioned and ready to use, as you'd have it locally.

Detailed instruction and config options are available on [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean) plugin page. Below is the short version.

#### Usage

1.  Provide your Client ID and API key (grab them from DigitalOcean Control Panel, API section) into Vagrant file options, `provider.client_id` and `provider.api_key` respectively.

2.  Optionally configure other parameters, like size, region etc.

	**Note** that this configuration is only tested with **CentOS 6** - there why you should stick with it. Also, because rsync is missing in DigitalOcean CentOS 6.5 box and it's required by vagrant-digitalocean plugin - we stick at this moment to CentOS 6.4.

3.  As mentioned in the plugin's doc, on Mac you might need to install curl-ca-bundle: `brew install curl-ca-bundle`

4.  Install vagrant-digitalocean plugin and run vagrant up with --provider param:

	```bash
	vagrant plugin install vagrant-digitalocean
	vagrant up --provider=digital_ocean
	```

## Tips & Tricks

#### Mount VM's `/var/www` to your filesystem

The web root folder to all Nginx vhosts is `/var/www` and it's exported via NFS, ready to mount to your filesystem. You can mount it using:
```
sudo mount_nfs -o async,udp,vers=3,resvport,intr,rsize=32768,wsize=32768,soft 192.168.66.6:/var/www /Volumes/vc-typo3-var-www
```
Or simply run `./mount-vm.sh`

Ergo you mount VM's filesystem to your host machine - not the other way, like when using Vagrant's `synced_folder` directive. **It gives you much better performance** even if you'd use it with `type:'nfs'` option. Quick tests with `ab` for default TYPO3 Neos installation for its home page show ca. 300% difference (in comparison to synced\_folder with type:'nfs'). It makes huge difference when working with TYPO3 in FLOW_CONTEXT=Development, with uncached requests (i.e. 300..1000ms instead of 1000..3000ms).

#### Change default provider

Add e.g. `export VAGRANT_DEFAULT_PROVIDER=parallels` to your `.bash_profile`


## Author

Author: ryzy (<marcin@ryzycki.com>)