vhost_name = node[:app][:flow][:vhost]
vhost_dir = "#{node[:system][:www_root]}/#{vhost_name}"

#
# TYPO3 Flow vhost
#
template "#{node['nginx']['dir']}/sites-available/#{vhost_name}" do
  source 'nginx/site-typo3.erb'
  variables({
      :vhost_name => vhost_name
  })
  notifies :reload, 'service[nginx]'
end
nginx_site vhost_name


#
# Install TYPO3 Flow
#
execute "composer --no-interaction --no-progress --keep-vcs --dev create-project typo3/flow-base-distribution #{vhost_name}" do
  cwd node[:system][:www_root]
  user node[:app][:user]
  group node[:app][:group]
  environment ({
      :COMPOSER_HOME => node[:system][:composer_home]
  })
  not_if "test -d #{vhost_dir}"
end

execute "./flow core:setfilepermissions vagrant #{node[:app][:user]} #{node[:app][:group]}" do
  cwd vhost_dir
  only_if "test -d #{vhost_dir}"
end

execute 'TYPO3 Flow post-installation' do
  cwd vhost_dir
  command '
    ./flow cache:warmup;
  '
  cwd vhost_dir
  user node[:app][:user]
  group node[:app][:group]
end
