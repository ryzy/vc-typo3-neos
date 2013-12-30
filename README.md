# TYPO3 Neos with Vagrant

Complete environment for TYPO3 Neos using Vagrant + Chef + Berkshelf provisioning.

##### Features:
* CentOS 6 based
* Chef + Berkshelf provisioning
* MySQL 5.5 / Nginx / PHP 5.5 installed && configured
* phpMyAdmin
* TYPO3 Neos installed

# Requirements

1. Install [Vagrant](http://www.vagrantup.com/)
2. Install [VirtualBox](https://www.virtualbox.org/)
3. Make sure you use Ruby 1.9.x or 2.x.
   You might follow this article on [how to install different version of Ruby using RVM](http://misheska.com/blog/2013/06/16/using-rvm-to-manage-multiple-versions-of-ruby/)).
4. Make sure you have Ruby Bundler installed:
   ```[sudo] gem install bundler```

# Usage

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

Go to [192.168.66.6](http://192.168.66.6/) to see VM's default vhost. You'll see there phpinfo() and link to phpMyAdmin (user:root, password:password)

Add `neos.local` to your `hosts` file:
```192.168.66.6 neos.local```

Go to [neos.local](http://neos.local/) to see TYPO3 Neos page (or [neos.local/setup](http://neos.local/setup) to kick off installation process).

# Tips & Tricks

1. Because NFS is used to mount host's `shared/` folder inside VM, **you'll be asked for your sudo password** each time VM is up/halt'ed. Add following line to your `visudo` to allow executing Vagrant's NFS-related commands without asking for password:
  `%admin ALL=(ALL) NOPASSWD:/bin/bash -c echo * /etc/exports, /usr/bin/sed * /etc/exports, /sbin/nfsd restart`
  Note: TYPO3 Neos uses many files (especially if you leave CVS files) - and according to [some benchamarks](http://docs-v1.vagrantup.com/v1/docs/nfs.html) it's 10..100 times faster than standard synced folders. Therefore using NFS synced folders is advised.

# Author

Author:: ryzy (<marcin@ryzycki.com>)
