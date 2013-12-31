include_recipe "mysql::server"
include_recipe "database::mysql"

# extra config
template "#{node['mysql']['server']['directories']['confd_dir']}/extra.cnf" do
  source 'mysql-extra.cnf.erb'
  notifies :reload, 'service[mysql]', :immediately
end

# define mysql connection parameters
mysql_connection_info = {
  :host     => '127.0.0.1',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

db_name = node[:app][:neos][:db_name]
db_user = node[:app][:neos][:db_user]
db_pass = node[:app][:neos][:db_pass]

mysql_database db_name do
  connection mysql_connection_info
  action :create
end

mysql_database_user db_user do
  connection    mysql_connection_info
  password      db_pass
  database_name "#{db_name}%"
  host          '%'
  privileges    [:all]
  action        :grant
end

mysql_database 'flush the privileges' do
  connection mysql_connection_info
  sql        'flush privileges'
  action     :query
end
