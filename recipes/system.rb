# add the EPEL repo
yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :create
end

# add the Remi repo
yum_repository 'remi' do
  description 'Les RPM de remi pour Enterprise Linux $releasever - $basearch'
  mirrorlist 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  action :create
end

# add the Remi PHP 5.5 repo (@see webserver.rb where PHP is installed)
yum_repository 'remi-php55' do
  description 'Les RPM de remi de PHP 5.5 pour Enterprise Linux $releasever - $basearch'
  mirrorlist 'http://rpms.famillecollet.com/enterprise/$releasever/php55/mirror'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  action :create
end

# add Nginx repo (@see webserver.rb where nginx is installed)
yum_repository 'nginx' do
  description 'nginx repo'
  baseurl 'http://nginx.org/packages/centos/6/$basearch/'
  gpgkey 'http://nginx.org/keys/nginx_signing.key'
  action :create
end


log 'Running yum update...'
execute "yum update -y"
log 'Yum update finished.'

# Install C, GCC, make etc
include_recipe 'build-essential'

# Install extra packages (user software etc)
node[:system][:packages].each do |pkg|
  package pkg do
    action :install
  end
end
