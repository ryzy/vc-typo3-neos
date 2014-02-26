#
# TYPO3 Neos
#
default['app']['neos'] = {
  # base vhost name
  'vhost_base_name' => 'neos',
  # Neos database settings
  'db' => {
    :user => 'typo3_neos',
    :pass => 'password',
    :name => 'typo3_neos',
    :host => node['app']['mysql_host']
  },
  
  # Neos post-install actions
  'install' => {
    # whether to do ./flow doctrine:migrate
    'migrate_doctrine' => true,
    # Neos post-install: package site to import (or false to skip the step)
    'site_package_key' => 'TYPO3.NeosDemoTypo3Org',
    # Neos post-install: whether to create admin user (set to false to skip the step)
    'create_admin_user' => {
      'username' => 'admin',
      'password' => 'password',
      'first_last_name' => 'Admin User', # Note: 2 parts space-separated required: FIRST LAST name
    }
  }
}
