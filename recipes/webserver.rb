group node[:app][:group]

user node[:app][:user] do
  group node[:app][:group]
  system true
  shell "/bin/bash"
end

#
# Install PHP
#
include_recipe "php"

# Install PHP packages, beginning with php-fpm:
package 'php-fpm'
node[:system][:php_packages].each do |pkg|
  package pkg
end

# make sure PHP-FPM is up and running
service 'php-fpm' do
  action [ :enable, :start ]
end



#
# Nginx
#
include_recipe "nginx"
