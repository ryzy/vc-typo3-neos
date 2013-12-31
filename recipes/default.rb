#
# Cookbook Name:: vc-typo3
# Recipe:: default
#
# Copyright (C) 2014 ryzy
#

include_recipe "vc-typo3::system"           # system basic setup (repos, tweaks)
include_recipe "vc-typo3::user"             # user preferences etc
include_recipe "vc-typo3::database"
include_recipe "vc-typo3::webserver-nginx"
include_recipe "vc-typo3::webserver-php"
include_recipe "vc-typo3::webserver-typo3"
include_recipe "vc-typo3::nfs"              # NFS exports
