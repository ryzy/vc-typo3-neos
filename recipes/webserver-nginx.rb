group node[:app][:group]

user node[:app][:user] do
  group node[:app][:group]
  system true
  shell "/bin/bash"
end

# Change 'vagrant' user (used to log in by defautl by 'vagrant ssh')
# so it has 'www-data' group to easily manage 'www-data' files
user 'vagrant' do
  group node[:app][:group]
end


#
# Nginx
#
include_recipe 'nginx'
include_recipe 'nginx::http_realip_module'
include_recipe 'nginx::http_gzip_static_module'
include_recipe 'nginx::http_spdy_module'


#
# configure default vhost in /var/www/default
#
directory "#{node[:system][:www_root]}/default" do
  owner node[:app][:user]
  group node[:app][:group]
  mode 00775
  recursive true
end

# disable default.conf from nginx/conf.d/default.conf
nginx_default_vhost = "#{node['nginx']['dir']}/conf.d/default.conf"
nginx_default_vhost_disabled = "#{node['nginx']['dir']}/conf.d/default.conf.disabled"
execute "disable_nginx_default.conf_vhost" do
  command "mv #{nginx_default_vhost} #{nginx_default_vhost_disabled}"
  user 'root'
  creates nginx_default_vhost_disabled
  notifies :reload, 'service[nginx]'
end

# vhost default
template "#{node['nginx']['dir']}/sites-available/default" do
  source 'nginx/site-default.conf.erb'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end
nginx_site 'default' do
  enable true
end

# Put there index.php file
template "#{node[:system][:www_root]}/default/index.php" do
  source "nginx/index.php.erb"
  mode   00775
  owner node[:app][:user]
  group node[:app][:group]
end
