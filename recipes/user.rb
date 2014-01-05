# user 'vagrant' belongs to 'www-data' - make sure it creates files
# which are also writable to 'www-data' group
execute "echo 'umask 002' > /home/vagrant/.bashrc"
# Make files created by 'www-'data user also writable to its group 'www-data'
execute "echo 'umask 002' > #{node[:system][:www_root]}/.bashrc"

