include_recipe "mysql::server"
#include_recipe "database::mysql"

# define mysql connection parameters
mysql_connection_info = {
  :host     => "localhost", 
  :username => "root", 
  :password => node['mysql']['server_root_password']
}
