#
# Cookbook Name:: vc-typo3
# Recipe:: default
#
# Copyright (C) 2013 ryzy
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "vc-typo3::system"
include_recipe "vc-typo3::database"
include_recipe "vc-typo3::webserver-nginx"
include_recipe "vc-typo3::webserver-php"
include_recipe "vc-typo3::webserver-typo3"
