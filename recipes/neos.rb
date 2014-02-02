vhost_name = node['app']['neos']['vhost_base_name']
vhost_dir = "#{node['system']['www_root']}/#{vhost_name}"

service 'nginx' do
  action :nothing
end

# Common include*.conf file(s) used in Neos-related vhosts
template "#{node['nginx']['dir']}/include-neos-rewrites.conf" do
  source 'nginx/include-neos-rewrites.erb'
end

# Neos vhost
template "#{node['nginx']['dir']}/sites-available/#{vhost_name}" do
  source 'nginx/site-neos.erb'
  variables({
      :vhost_name => vhost_name
  })
  notifies :reload, 'service[nginx]'
end
nginx_site vhost_name

# Neos db
mysql_database node['app']['neos']['db']['name'] do
  connection    node['app']['mysql_connection_info']
  action :create
end
mysql_database_user node['app']['neos']['db']['user'] do
  connection    node['app']['mysql_connection_info']
  password      node['app']['neos']['db']['pass']
  database_name "#{node['app']['neos']['db']['name']}"
  host          '%'
  privileges    [:all]
  action        :grant
end

#
# Install TYPO3 Neos
#

# clone git repo
git vhost_dir do
  repository 'git://git.typo3.org/Neos/Distributions/Base.git'
  reference 'master'
  user node['app']['user']
  group node['app']['group']
  action :sync
end

# execute composer install
execute "composer install --dev --no-interaction --no-progress" do
  cwd vhost_dir
  user node['app']['user']
  group node['app']['group']
  environment (node['system']['composer_env'])
  not_if "test -f #{vhost_dir}/composer.lock"
end

# prepare Settings.yaml with database connection info
settings_yaml = "#{vhost_dir}/Configuration/Settings.yaml"
template settings_yaml do
  source 'typo3/Settings.yaml.erb'
  variables({
      :db => node['app']['neos']['db']
  })
  user node['app']['user']
  group node['app']['group']
  not_if "test -f #{settings_yaml}"
end

# Neos post-installation stuff
execute 'TYPO3 Neos post-installation: file permissions' do
  cwd vhost_dir
  command "
    ./flow core:setfilepermissions vagrant #{node[:app][:user]} #{node[:app][:group]};
    chown -R vagrant:#{node[:app][:group]} .;
    chmod -R ug+rw .;
  "
end

execute 'TYPO3 Neos post-installation: site import, creating user etc...' do
  cwd vhost_dir
  command "
    ./flow doctrine:migrate;
    ./flow site:import --packageKey TYPO3.NeosDemoTypo3Org;
    ./flow cache:warmup;
    ./flow user:create --roles Administrator admin password Admin User;
  "
  user node['app']['user']
  group node['app']['group']
  # if PackageStates.php is present, we can be pretty sure Neos has been already provisioned
  not_if "test -f #{vhost_dir}/Configuration/PackageStates.php" 
end
