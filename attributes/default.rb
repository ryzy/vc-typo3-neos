# System: extra packages to install initially
default[:system][:packages] = ['vim','git','mc','htop','links']
# Root directory for www data
default[:system][:www_root] = '/var/www'
# COMPOSER_HOME set when executing composer
default[:system][:composer_home] = "#{node[:system][:www_root]}/.composer"
# COMPOSER_PROCESS_TIMEOUT: sometimes it takes a while, so make it longer then def. 300
default[:system][:composer_timeout] = '900' # Passed to env variables and must be string - otherwise Chef/Ruby triggers error
default[:system][:composer_env] = {
  'COMPOSER_HOME'             => node[:system][:composer_home],
  'COMPOSER_PROCESS_TIMEOUT'  => node[:system][:composer_timeout]
}

# PHP: user/group
default[:app][:group] = "www-data"
default[:app][:user] = "www-data"
# PHP-FPM sock path - see cookbook php-fpm/templates/default/pool.conf.erb
default[:app][:php_socket] = '/var/run/php-fpm-www.sock'

# DB user for TYPO3 apps
default[:app][:db_user] = 'typo3'
default[:app][:db_pass] = 'password'
default[:app][:db_host] = '127.0.0.1'

# TYPO3 Flow
default[:app][:flow][:vhost]    = 'flow.local'
default[:app][:flow][:db_name]  = "#{node[:app][:db_user]}_flow" # typo3_flow
# TYPO3 Neos
default[:app][:neos][:vhost]    = 'neos.local'
default[:app][:neos][:db_name]  = "#{node[:app][:db_user]}_neos" # typo3_neos
# TYPO3 CMS
default[:app][:typo3][:vhost]   = 'typo3.local'
default[:app][:typo3][:db_name] = "#{node[:app][:db_user]}_cms"


#
# MySQL settings
#
default['mysql']['remove_anonymous_users']          = true
default['mysql']['remove_test_database']            = true
default['mysql']['bind_address']                    = '0.0.0.0'
default['mysql']['tunable']['character-set-server'] = 'utf8'
default['mysql']['tunable']['collation-server']     = 'utf8_unicode_ci'
default['mysql']['tunable']['max_connections']      = '50'
default['mysql']['tunable']['max_allowed_packet']   = '32M'
default['mysql']['tunable']['log_error']                    = '/var/log/mysql/error.log'
default['mysql']['tunable']['log_warnings']                 = 2
default['mysql']['tunable']['log_queries_not_using_index']  = true
default['mysql']['tunable']['open-files-limit']     = '16384'
default['mysql']['tunable']['query_cache_size']     = '128M'
default['mysql']['tunable']['thread_cache_size']    = 16
default['mysql']['tunable']['table_cache']          = '2048'
default['mysql']['tunable']['table_open_cache']     = node['mysql']['tunable']['table_cache']
default['mysql']['tunable']['sort_buffer_size']     = '2M'
default['mysql']['tunable']['read_buffer_size']     = '1M'
default['mysql']['tunable']['read_rnd_buffer_size'] = '8M'
default['mysql']['tunable']['join_buffer_size']     = '1M'
default['mysql']['tunable']['tmp_table_size']       = '64M'
default['mysql']['tunable']['max_heap_table_size']  = node['mysql']['tunable']['tmp_table_size']

# MySQL password
default['mysql']['server_root_password'] = 'password'
default['mysql']['server_repl_password'] = node['mysql']['server_root_password']
default['mysql']['server_debian_password'] = node['mysql']['server_root_password']


#
# PHP settings
#
# PHP: extra packages/modules to install
default[:system][:php_packages] = ['php-opcache','php-pecl-gmagick']
# PHP tuning
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
default['nginx']['client_max_body_size'] = '99M'



#
# RVM
#
default['rvm']['default_ruby']      = 'ruby-2.0.0-p353'
default['rvm']['user_default_ruby'] = node['rvm']['default_ruby']

default['rvm']['vagrant']['system_chef_client'] = '/opt/chef/bin/chef-client'
default['rvm']['vagrant']['system_chef_solo'] = '/opt/chef/bin/chef-solo'
