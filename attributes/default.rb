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
