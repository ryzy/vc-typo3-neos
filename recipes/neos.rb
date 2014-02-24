vhost_name = node['app']['neos']['vhost_base_name'] # e.g. neos
vhost_dir = "#{node['system']['www_root']}/#{vhost_name}" # e.g. /var/www/neos

service 'nginx' do
  action :nothing
end

# Common include*.conf file(s) used in Neos-related vhosts
template "#{node['nginx']['dir']}/include-neos-rewrites.conf" do
  source 'nginx/include-neos-rewrites.erb'
end

#
# Neos vhost
#
template "#{node['nginx']['dir']}/sites-available/#{vhost_name}" do
  source 'nginx/site-neos.erb'
  variables({
      :vhost_name => vhost_name
  })
  notifies :reload, 'service[nginx]'
end
nginx_site vhost_name

# also add neos hosts to /etc/hosts file, so you can connect to them from localhost
execute "echo #{node['ipaddress']} #{vhost_name} #{vhost_name}.dev #{vhost_name}.test >> /etc/hosts" do
  not_if "cat /etc/hosts | grep #{vhost_name}.test"
end


#
# Neos db
#
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

#
# Neos: file permissions
#
execute 'TYPO3 Neos post-installation: file permissions' do
  cwd vhost_dir
  command "
    ./flow core:setfilepermissions #{node[:app][:user]} #{node[:app][:user]} #{node[:app][:group]};
    chmod -R ug+rw .;
  "
end


#
# flow doctrine:migrate
#
mysql_cmd = "mysql -u#{node['app']['neos']['db']['user']} -p#{node['app']['neos']['db']['pass']} #{node['app']['neos']['db']['name']} -sN"

execute 'TYPO3 Neos post-installation: flow doctrine:migrate' do
  cwd vhost_dir
  command './flow doctrine:migrate'
  user node['app']['user']
  group node['app']['group']
  not_if "#{mysql_cmd} -e 'SHOW TABLES' | grep migrationstatus"
end if node['app']['neos']['install']['migrate_doctrine'] # only if migrate_doctrine flag is set

#
# flow user:create, create 1st admin user
#
ud = node['app']['neos']['install']['create_admin_user']
# create admin user with provided data
execute 'TYPO3 Neos post-installation: flow user:create' do
  cwd vhost_dir
  command "./flow user:create --roles Administrator #{ud['username']} #{ud['password']} #{ud['first_last_name']}"
  user node['app']['user']
  group node['app']['group']
  only_if "#{mysql_cmd} -e 'SELECT COUNT(*) FROM typo3_flow_security_account' | grep ^0" # only run if Neos account table is empty (COUNT() returns 0)
end if ud.is_a?(Hash) && ud.length

#
# flow site:import, import default site
#
execute 'TYPO3 Neos post-installation: flow site:import' do
  cwd vhost_dir
  command "./flow site:import --packageKey #{node['app']['neos']['install']['site_package_key']}"
  user node['app']['user']
  group node['app']['group']
  only_if "#{mysql_cmd} -e 'SELECT COUNT(*) FROM typo3_neos_domain_model_site' | grep ^0" # only run if Neos sites table is empty (COUNT() returns 0)
end if node['app']['neos']['install']['site_package_key'] # only if site package key is provided

#
# flow: cache:warmup
#
execute 'TYPO3 Neos post-installation: cache:warmup' do
  cwd vhost_dir
  command "
    FLOW_CONTEXT=Production  ./flow cache:warmup;
    FLOW_CONTEXT=Development ./flow cache:warmup;
  "
  user node['app']['user']
  group node['app']['group']
end
