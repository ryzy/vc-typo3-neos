#
# Install PHP
#
include_recipe 'php'

node[:system][:php_packages].each do |pkg|
  package pkg
end

include_recipe 'php-fpm'

# Make sure /var/lib/php (where PHP stores sessions by default) has correct ownership
execute "chown -R #{node[:app][:user]}:#{node[:app][:group]} /var/lib/php* /var/log/php*"

# Override default fastcgi_params with more tuned version
template "#{node[:nginx][:dir]}/fastcgi_params" do
  source 'nginx/fastcgi_params'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end

# Define upstream php which can be used in vhost configurations
template "#{node['nginx']['dir']}/conf.d/upstream_php.conf" do
  source 'nginx/upstream_php.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end


#
# PHP Composer
#
include_recipe 'composer'


#
# Install phpMyAdmin
#
package 'phpMyAdmin'

link '/var/www/default/phpMyAdmin' do
 to '/usr/share/phpMyAdmin' # this is where package phpMyAdmin is installed by default
 owner node[:app][:user]
 group node[:app][:group]
end
