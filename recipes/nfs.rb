#
# NFS server
#
#include_recipe 'nfs'
include_recipe 'nfs::server'

# For performance reasons, keep /var/www inside VM filesystem
# and export it via NFS. User uid:80 and group 80 
# are created in recipe webserver-nginx
nfs_export '/var/www' do
  network '*'
  writeable true
  sync false
  options ['all_squash', 'anonuid=80', 'anongid=80']
end
