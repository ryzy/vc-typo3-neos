# Install RVM with ruby
include_recipe 'rvm::system'

# fix so Vagrant's chef-solo works correctly after installing RVM
include_recipe 'rvm::vagrant'
execute 'mv -f /usr/local/bin/chef* /usr/bin/.' do
  only_if 'test -f /usr/local/bin/chef-solo'
end

