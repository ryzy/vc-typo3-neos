# System: extra packages to install initially
default[:system][:packages] = ['mc','htop']
# PHP: extra packages to install (e.g. php-gd)
default[:system][:php_packages] = []
# PHP: user/group
default[:app][:group] = "www-data"
default[:app][:user] = "www-data"


#
# MySQL settings
#
default['mysql']['tunable']['max_allowed_packet']   = '32M'
default['mysql']['remove_anonymous_users']          = true
default['mysql']['remove_test_database']            = true
default['mysql']['tunable']['character-set-server'] = 'utf8'
default['mysql']['tunable']['collation-server']     = 'utf8_general_ci'
default['mysql']['tunable']['max_connections']      = '50'
default['mysql']['tunable']['skip-character-set-client-handshake'] = true
default['mysql']['tunable']['skip-name-resolve']                   = true
default['mysql']['security']['skip_show_database']  = true

default['mysql']['server_root_password'] = 'password'
default['mysql']['server_repl_password'] = node['mysql']['server_root_password']
default['mysql']['server_debian_password'] = node['mysql']['server_root_password']


#
# PHP settings
#
default['php']['fpm_user']      = node[:app][:user]
default['php']['fpm_group']     = node[:app][:group]
default['php']['directives'] = {
  'memory_limit' => '256M',
  'display_errors' => 'On',
  'display_startup_errors' => 'On',
  'post_max_size' => '99M',
  'upload_max_filesize' => '99M',
  'date.timezone' => 'Europe/London',
}


#
# Nginx settings
#
default['nginx']['user']        = 'www-data'
default['nginx']['group']       = 'www-data'
