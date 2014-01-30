# Install RVM with ruby
include_recipe 'rvm::system'

# fix so Vagrant's chef-solo works correctly after installing RVM
include_recipe 'rvm::vagrant'
execute 'mv -f /usr/local/bin/chef* /usr/bin/.' do
  only_if 'test -f /usr/local/bin/chef-solo'
end

#
# Install common gems
#
rvm_gem 'sass' do
  version     '3.3.0.rc.2'
end

rvm_gem 'compass' do
  version     '1.0.0.alpha.17'
end
