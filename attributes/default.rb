# System: extra packages to install initially
default[:system][:packages] = ['mc','htop']
# PHP: extra packages to install (e.g. php-gd)
default[:system][:php_packages] = []
# Root director for www data
default[:system][:www_root] = '/var/www'
# PHP: user/group
default[:app][:group] = "www-data"
default[:app][:user] = "www-data"
# PHP-FPM sock path - see cookbook php-fpm/templates/default/pool.conf.erb
default[:app][:php_socket] = '/var/run/php-fpm-www.sock' 


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
# MySQL password
default['mysql']['server_root_password'] = 'password'
default['mysql']['server_repl_password'] = node['mysql']['server_root_password']
default['mysql']['server_debian_password'] = node['mysql']['server_root_password']


#
# PHP settings
#
default['php']['fpm_user']      = node[:app][:user]
default['php']['fpm_group']     = node[:app][:group]
default['php']['directives'] = { # extra directives added to the end of php.ini
  'memory_limit' => '256M',
  'display_errors' => 'On',
  'display_startup_errors' => 'On',
  'post_max_size' => '99M',
  'upload_max_filesize' => '99M',
  'date.timezone' => 'Europe/London',
}
# PHP-FPM settings + pools
default['php-fpm']['user'] = node['php']['fpm_user']
default['php-fpm']['group'] = node['php']['fpm_group']
default['php-fpm']['pools'] = [
  {
    :name => 'www',
    :user => node['php-fpm']['user'],
    :group => node['php-fpm']['group'],
    :max_children => 10,
    :start_servers => 2,
    :min_spare_servers => 2,
    :max_spare_servers => 5,
    :catch_workers_output => 'yes',
    :php_options => {
#      'php_admin_flag[log_errors]' => 'on', 
#      'php_admin_value[memory_limit]' => '32M' 
    }
  }
]



#
# Nginx settings
#
default['nginx']['user']                  = node[:app][:user]
default['nginx']['group']                 = node[:app][:group]
default['nginx']['default_site_enabled']  = false
default['nginx']['worker_processes']      = 2
default['nginx']['realip']['addresses']   = ['0.0.0.0/32']
