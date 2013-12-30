group node[:app][:group] do
  append true
  gid 80
  members 'vagrant'
end

user node[:app][:user] do
  uid 80
  gid 80
  system true
  home '/var/www'
  shell '/bin/bash'
  supports :manage_home=>false
end



#
# Nginx
#
include_recipe 'nginx'
include_recipe 'nginx::http_realip_module'
include_recipe 'nginx::http_gzip_static_module'
include_recipe 'nginx::http_spdy_module'

template "#{node['nginx']['dir']}/conf.d/upstream_php.conf" do
  source 'nginx/upstream_php.conf.erb'
  notifies :reload, 'service[nginx]'
end

# configure default vhost in /var/www/default
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
  source 'nginx/site-default.erb'
  notifies :reload, 'service[nginx]'
end
nginx_site 'default' do
  enable true
end

# Put there index.php file
template "#{node[:system][:www_root]}/default/index.php" do
  source "index.php.erb"
  mode   00775
  owner node[:app][:user]
  group node[:app][:group]
end
