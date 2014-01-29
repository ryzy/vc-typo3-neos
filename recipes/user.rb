# user 'vagrant' belongs to 'www-data' - make sure it creates files
# which are also writable to 'www-data' group
execute "echo 'umask 002' > /home/vagrant/.bashrc"
# Make files created by 'www-'data user also writable to its group 'www-data'
execute "echo 'umask 002' > #{node[:system][:www_root]}/.bashrc" do
  only_if "test -d #{node[:system][:www_root]}"
end


# PS settings
template "/etc/profile.d/ps.sh" do
  source 'user/profile_ps.erb'
end
