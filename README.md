# TYPO3 Neos with Vagrant/Chef

Complete environment for TYPO3 Neos using Vagrant + Chef + Berkshelf provisioning.

## UPDATE - THIS REPO IS OBSOLETE

**Nowadays I advocate for running TYPO3 inside Docker containers.** Please have a look at [million12/typo3-flow-neos-abstract](https://github.com/million12/docker-typo3-flow-neos-abstract) and [million12/typo3-neos](https://github.com/million12/docker-typo3-neos) Docker images. This repository is **not maintained** any longer.

---

#### Features

To make sure this VM setup suits TYPO3 Flow/Neos development, the following are included in the setup:

* machine CentOS 6.5 based

* Vagrant provisioning done by [Chef](http://www.getchef.com/chef/) + [Berkshelf](http://berkshelf.com/). Tested by [kitchen.ci](http://kitchen.ci/)

* Vagrant configuration for VirtualBox / Parallels Desktop / [DigitalOcean.com](https://www.digitalocean.com/) / [Rackspace](http://www.rackspace.co.uk/) providers. Same with kitchen.ci tests.

* LEMP stack (Linux/Nginx/MySQL/PHP) environment installed/configured using parent [ryzy/vc-lemp-server](https://github.com/ryzy/vc-lemp-server) cookbook:
  * MySQL 5.5 (+tuning)
  * Nginx (latest 1.4.x)
  * PHP (latest 5.5.x)
  * phpMyAdmin, [OpCacheGUI](https://github.com/PeeHaa/OpCacheGUI) installed

* TYPO3 Neos installed (into /var/www/neos)
	* vhosts `neos`, `neos.dev` and `neos.test` available (configured with FLOW_CONTEXT set to Production, Development, Testing respectively)
	* user `admin` with password `password` already added to TYPO3 Neos

## Requirements

1. Install [Vagrant](http://www.vagrantup.com/)
2. Depends on your chosen Vagrant provider: install VirtualBox **OR** Parallels Desktop **OR** set up an account on [DigitalOcean.com](https://www.digitalocean.com/) / [Rackspace](http://www.rackspace.co.uk/)
3. Make sure you have Ruby 2.x installed.
4. Make sure you have Ruby Bundler installed:
  ```[sudo] gem install bundler```

## Usage

* **Install** required gems (specified in Gemfile) and vagrant plugins:

  ```bash
  bundle install
  vagrant plugin install vagrant-berkshelf
  vagrant plugin install vagrant-omnibus
  ```

  * (Optional) If you're using VirtualBox provider, also install [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) plugin:
    ```
    vagrant plugin install vagrant-vbguest
    ```

* **Run** `vagrant up` to kick off your machine:
  ```bash
  vagrant up
  # or, if you want to use provider different than VirtualBox:
  vagrant up --provider=CHOSEN_PROVIDER
  ```

  It might happen that `vagrant up` **fails due to temporary reasons**. Just try again with `vagrant provision` (to just re-provision the server) or `vagrant reload --provision` (to reboot and then re-provision VM).

  Another reason for failures during `vagrant up` might be the vagrant-berkshelf plugin. Here are some examples of error messages:
  `Could not open library dep_gecode.bundle`
  or
  `cannot load such file -- hashie/hash_extensions`

  It might help then to reinstall vagrant-berkshelf:

  ```bash
  vagrant plugin install vagrant-berkshelf --plugin-version '>= 2.0.1'
  ```

* **Go to VM_IP_ADDRESS** to see VM's default vhost. You'll see there phpinfo() and link to phpMyAdmin, OpCacheGUI.
  * Note: if you're not sure about the VM IP address, just log in there using `vagrant ssh` and run `ifconfig`. 

* **Map `neos`, `neos.dev`, `neos.test` in your `hosts` file** to your VM_IP_ADDRESS address, e.g.
  ```bash
  1.2.3.4 neos neos.dev neos.test
  ```

* **Go to [neos.dev](http://neos.dev/)** to see TYPO3 Neos page.

* **Start happy coding!**

  * You'll probably download/upload files via SFTP, mapping your local project paths to the remote paths.

### Users / Passwords, security

All passwords (apart of the `root`) are defined in attributes/default.rb:

* **ssh:** user: root, passw: `vagrant` (or: your private SSH key in case of DigitalOcean, Rackspace providers)
* **ssh:** user: vagrant, passw: `vagrant` (or: same as above)
* **mysql:** user: root, passw: `password`
* **typo3:** user: admin, passsw: `password`

You can connect to MySQL from outside VM machine as user _root_ is added with '%' host. And there's no iptables running, so no firewall setup.


## Provider: Parallels Desktop

Why bother, if VirtualBox is so cool, free and there's plenty of ready to use image boxes? Well, look up [some](http://mitchellh.com/comparing-filesystem-performance-in-virtual-machines) [benchmarks](http://www.macobserver.com/tmo/article/benchmarking-parallels-fusion-and-virtualbox-against-boot-camp) - I'm sure you'll appreciate 3-digit % difference in Neos performance. E.g. during the tests on the same machine, Neos back-end loaded in 800..1000ms for VB, vs 300..500ms for PD9 (values for Development context).

#### Usage

* `vagrant plugin install vagrant-parallels`
* `vagrant up --provider=parallels`
* Optionally, add line with `export VAGRANT_DEFAULT_PROVIDER=parallels` to your .bash_profile to use this provider as default.

## Provider: DigitalOcean

DigitalOcean configuration is already included in Vagrantfile. After `vagrant up --provider=digital_ocean` you'll have up & running droplet there, provisioned and ready to use, as you'd have it locally.

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

More detailed instruction and config options available on [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean) plugin page.

## Provider: Rackspace

Rackspace configuration is already included in Vagrantfile. After `vagrant up --provider=rackspace` you'll have up & running droplet there, provisioned and ready to use, as you'd have it locally.

You'll need to install [vagrant-rackspace](https://github.com/mitchellh/vagrant-rackspace) plugin:

```vagrant plugin install vagrant-rackspace```

More detailed instruction and config options available on [vagrant-rackspace](https://github.com/mitchellh/vagrant-rackspace) plugin page.


## Tips & Tricks

#### Change default provider

Add e.g. `export VAGRANT_DEFAULT_PROVIDER=parallels` to your `.bash_profile`


## Author

Author: ryzy marcin@m12.io

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
