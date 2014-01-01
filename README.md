# TYPO3 Neos with Vagrant

Complete environment for TYPO3 Neos using Vagrant + Chef + Berkshelf provisioning.

##### Features:
* CentOS 6.5 based
* Vagrant provisioning is done by Chef + Berkshelf
* Web environment installed/configured:
  * MySQL 5.5
  * Nginx
  * PHP 5.5
  * phpMyAdmin
* TYPO3 Neos installed (into /var/www/neos.local)

## Requirements

1. Install [Vagrant](http://www.vagrantup.com/)
2. Install [VirtualBox](https://www.virtualbox.org/)
3. Make sure you use Ruby 1.9.x or 2.x.
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

**Go to [192.168.66.6](http://192.168.66.6/)** to see VM's default vhost. You'll see there phpinfo() and link to phpMyAdmin (user:root, password:password)

Add `neos.local` to your `hosts` file:
```bash
192.168.66.6 neos.local
```

**Go to [neos.local](http://neos.local/)** to see TYPO3 Neos page (or [neos.local/setup](http://neos.local/setup) to kick off installation process).

Start happy coding! If you need, mount `/var/www` to your local filesystem:
```
sudo mount_nfs -o async,udp,vers=3,resvport,intr,rsize=32768,wsize=32768,soft 192.168.66.6:/var/www /Volumes/vc-typo3-var-www
```

#### Users / Passwords, security

All passwords (apart of the `root`) are defined in attributes/default.rb:

* **ssh:** root / vagrant
* **mysql:** root / password
* **mysql:** typo3_neos / password, db name: typo3\_neos

You can connect to MySQL from outside VM machine as user _root_ is added with '%' host. And there's no iptables running, so no firewall setup.

## Tips & Tricks

#### Mount VM's `/var/www` to your filesystem

This VM is configured to export `/var/www` via NFS so you can easily mount it to your filesystem - not the other way, like when using Vagrant's `synced_folder` directive. **It gives you much better performance** even if you'd use it with `type:'nfs'` option. Quick tests with `ab` for default TYPO3 Neos installation for its home page show ca. 300% difference (in comparison to synced\_folder with type:'nfs'). It makes huge difference when working with TYPO3 in FLOW_CONTEXT=Development, with uncached requests (i.e. 300..1000ms instead of 1000..3000ms).


## Author

Author: ryzy (<marcin@ryzycki.com>)