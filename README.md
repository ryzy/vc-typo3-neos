# TYPO3 Neos with Vagrant

Complete environment for TYPO3 Neos using Vagrant + Chef provisioning.
Features:
* CentOS 6 based
* Chef + Berkshelf provisioning
* MySQL 5.5
* Nginx
* PHP 5.5
* phpMyAdmin
* TYPO3 Neos

# Requirements

1. Install [Vagrant](http://www.vagrantup.com/)
2. Install [VirtualBox](https://www.virtualbox.org/)
3. Make sure you use Ruby 1.9 (e.g. you might follow this article [how to install different version of Ruby using RVM](http://misheska.com/blog/2013/06/16/using-rvm-to-manage-multiple-versions-of-ruby/))
4. Run `bundle install` to install required gems specified in Gemfile (i.e. berkshelf, vagrant plugins etc)
  
# Usage

```bash
vagrant up
```

# Author

Author:: ryzy (<marcin@ryzycki.com>)
