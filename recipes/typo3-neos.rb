vhost_name = node[:app][:neos][:vhost]
vhost_dir = "#{node[:system][:www_root]}/#{vhost_name}"

#
# TYPO3 Neos vhost
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
# Install TYPO3 Neos
#
execute "composer --no-interaction --no-progress --dev create-project typo3/neos-base-distribution #{vhost_name}" do
  cwd node[:system][:www_root]
  user node[:app][:user]
  group node[:app][:group]
  environment (node[:system][:composer_env])
  not_if "test -d #{vhost_dir}"
end

settings_yaml = "#{vhost_dir}/Configuration/Settings.yaml"
template settings_yaml do
  source 'typo3/Settings.yaml.erb'
  variables({
      :db_name => node[:app][:neos][:db_name],
      :db_user => node[:app][:db_user],
      :db_pass => node[:app][:db_pass],
      :db_host => node[:app][:db_host]
  })
  user node[:app][:user]
  group node[:app][:group]
  not_if "test -f #{settings_yaml}"
end

execute 'TYPO3 Neos post-installation' do
  cwd vhost_dir
  command "
    sudo ./flow core:setfilepermissions vagrant #{node[:app][:user]} #{node[:app][:group]};
    sudo chmod -R ug+rw .;
    ./flow cache:warmup;
  "
  user node[:app][:user]
  group node[:app][:group]
end
