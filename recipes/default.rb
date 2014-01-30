#
# Cookbook Name:: vc-typo3
# Recipe:: default
#
# Copyright (C) 2014 ryzy
#

include_recipe 'vc-typo3::system'           # system basic setup (repos, tweaks)
include_recipe 'vc-typo3::nfs'              # NFS exports
include_recipe 'vc-typo3::web-tools'        # Web tools: ruby, sass, compass etc
include_recipe 'vc-typo3::web-db'           # Web: MySQL
include_recipe 'vc-typo3::web-nginx'        # Web: Nginx server
include_recipe 'vc-typo3::web-php'          # Web: PHP, PHP-FPM, composer, phpMyAdmin
include_recipe 'vc-typo3::typo3-flow'       # TYPO3 Flow installation
include_recipe 'vc-typo3::typo3-neos'       # TYPO3 Neos installation
include_recipe 'vc-typo3::user'             # user preferences etc
