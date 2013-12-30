vhost_name = node[:app][:neos][:vhost]
vhost_dir = "#{node[:system][:www_root]}/#{vhost_name}"

#
# Neos vhost
#
template "#{node['nginx']['dir']}/sites-available/#{vhost_name}" do
  source 'nginx/site-neos.erb'
  notifies :reload, 'service[nginx]'
end
nginx_site vhost_name


#
# Install TYPO3 Neos
#
execute "composer --no-interaction --no-progress --keep-vcs create-project typo3/neos-base-distribution #{vhost_name}" do
  cwd node[:system][:www_root]
  user node[:app][:user]
  not_if "test -d #{vhost_dir}"
end
