# TYPO3 Neos with Vagrant

Complete environment for TYPO3 Neos using Vagrant + Chef + Berkshelf provisioning.

##### Features

To make sure this VM setup suits TYPO3 Flow/Neos development, the following are included in the setup:

* machine is CentOS 6.5 based
* Vagrant provisioning is done by [Chef](http://www.getchef.com/chef/)(solo) + [Berkshelf](http://berkshelf.com/)
* Web environment installed/configured:
  * MySQL 5.5 (+tuning)
  * Nginx (latest 1.4.x)
  * PHP (latest 5.5.x)
  * phpMyAdmin installed
* TYPO3 Flow installed (into /var/www/flow.local)
* TYPO3 Neos pre-installed (into /var/www/neos.local)

## Requirements

1. Install [Vagrant](http://www.vagrantup.com/)
2. Install [VirtualBox](https://www.virtualbox.org/)
3. Make sure you have Ruby 1.9.x or 2.x.
  Note: you might follow this article on [how to install different version of Ruby using RVM](http://misheska.com/blog/2013/06/16/using-rvm-to-manage-multiple-versions-of-ruby/)).
4. Make sure you have Ruby Bundler installed:
  ```[sudo] gem install bundler```

## Usage

First you need to install required gems (specified in Gemfile) and vagrant plugins:

```bash
bundle install
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-omnibus
```

Later on simply use:
```bash
vagrant up
```
If vagrant up fails and it's due to some temporary reason, try 'vagrant provision' after machine was booted. Or file a ticket / pull request so it can be resolved permanently in the future version.

**Go to [192.168.66.6](http://192.168.66.6/)** to see VM's default vhost. You'll see there phpinfo() and link to phpMyAdmin (user:root, password:password)

Map **flow.local**, **neos.local** to your `hosts` file:
```bash
192.168.66.6 flow.local neos.local
```
**Go to [flow.local](http://flow.local/)** to see TYPO3 Flow page.
**Go to [neos.local](http://neos.local/)** to see TYPO3 Neos page (or [neos.local/setup](http://neos.local/setup) to kick off installation process).

And start happy coding!

You'll probably download/upload files via SFTP, mapping your local project paths to the remote paths. Optionally you might mount whole `/var/www` to your local filesystem - then read the point below.

#### Users / Passwords, security

All passwords (apart of the `root`) are defined in attributes/default.rb:

* **ssh:** root / vagrant
* **mysql:** root / password
* **mysql:** typo3 / password, db name(s): typo3\_neos, typo3\_flow, typo3\_cms

You can connect to MySQL from outside VM machine as user _root_ is added with '%' host. And there's no iptables running, so no firewall setup.

## Deploying to DigitalOcean

In the separate branch [digital-ocean](https://github.com/ryzy/vc-typo3/tree/digital-ocean) of this repo, you'll find Vagrant file configured to deploy this setup to [DigitalOcean.com](https://www.digitalocean.com/?refcode=58af8bab822f)

#### Usage

Detailed instruction and config options are available on [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean) plugin page. 

Short version:

1.  Provide your Client ID and API key (grab them from DigitalOcean Control Panel, API section) into `provider.client_id` and `provider.api_key` respectively.

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


## Author

Author: ryzy (<marcin@ryzycki.com>)