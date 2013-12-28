# TYPO3 Neos with Vagrant

Complete environment for TYPO3 Neos using Vagrant + Chef provisioning.
Features:
* CentOS 6 based
* Chef + Berkshelf provisioning
* MySQL 5.5 / Nginx / PHP 5.5 installed && configured
* phpMyAdmin
* TYPO3 Neos

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

# Author

Author:: ryzy (<marcin@ryzycki.com>)
