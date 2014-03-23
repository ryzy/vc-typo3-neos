## 2.1.1 (2014-03-23)

- [BUGFIX] Temporary fix for Chef::Exceptions::RedirectLimitExceeded while installing chruby

## 2.1.0 (2014-02-24)

- more tunable options for TYPO3 Neos - see attributes/default.rb
- lemp-server v0.3.0
- RVM dependency removed (lemp-server now uses simplistic chruby+ruby-build)
- nfs service, mount-vm.sh removed (due to vagrant 1.5 comming, @see lemp-server changelog)

## 2.0.0 (2014-02-02)

- Breaking changes: project split into two cookbooks: **[lemp-server](https://github.com/ryzy/vc-lemp-server)** and **typo3-neos**

  All LEMP (Linux, Nginx, MySQL, PHP) related stuff moved to independent **lemp-server** cookbook (so it's easy to create other dedicated environment based on it). Therefore **typo3-neos** depends on it (see metadata.rb where the dependency is specified).

## 1.3.0 (2014-01-30)

Features:

- RVM installed in the system, with default Ruby 2.0.0

Bugfixes:

- Default config.vm.network :private_network removed from global configuration as it might cause problems in other then VirtualBox providers. Thus overriden only for VB provider.

## 1.2.0 (2014-01-28)

Features:

- Parallels Desktop provider support + README
- general Vagrant file tidying up

Bugfixes:

- Default config.vm.network :private_network changed to "10.11.12.13" as Parallels Desktop provider didn't like the previous value and triggered error

## 1.1.0 (2014-01-25)

Features:

- DigitalOcean.com provider support + README

Bugfixes:

- Making sure that swap is on by default. On some CentOS boxes (e.g. DigitalOcean) there's no swap enabled by default, which causes crashes in case of memory use spikes.

## 1.0.0 (2014-01-16)

- 1st stable version
