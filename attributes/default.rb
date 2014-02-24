#
# TYPO3 Neos
#
default['app']['neos']['vhost_base_name'] = 'neos'
default['app']['neos']['db'] = {
  :user => 'typo3_neos',
  :pass => 'password',
  :name => 'typo3_neos',
  :host => node['app']['mysql_host']
}


# Neos post-install: whether to do ./flow doctrine:migrate
default['app']['neos']['install']['migrate_doctrine'] = true
# Neos post-install: whether to create admin user (set to false to skip the step)
default['app']['neos']['install']['create_admin_user'] = { 
  'username' => 'admin', 
  'password' => 'password', 
  'first_last_name' => 'Admin User', # Note: 2 parts space-separated required: FIRST LAST name
}
# Neos post-install: package site to import (or false to skip the step)
default['app']['neos']['install']['site_package_key'] = 'TYPO3.NeosDemoTypo3Org'
