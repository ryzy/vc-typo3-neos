# TYPO3 Neos with Vagrant


# Requirements

1. Install [Vagrant](http://www.vagrantup.com/) and  [VirtualBox](https://www.virtualbox.org/)
2. Install Vagrant plugins: 
  * [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) - to keep your VirtualBox Guest Additions up to date
  * [vagrant-omnibus](https://github.com/schisamo/vagrant-omnibus) - to install Chef on your VM
  * [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf) - to add Berkshelf integration to the Chef provisioners
  ```
  vagrant plugin install vagrant-vbguest
  vagrant plugin install vagrant-omnibus
  vagrant plugin install vagrant-berkshelf
  ```
3. Run `bundle install` to install gems specified in Gemfile
  
# Usage

# Attributes

# Recipes

# Author

Author:: ryzy (<marcin@ryzycki.com>)
