#
# Yum repositories
# 

# add the EPEL repo
r = yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :nothing
end
r.run_action(:create)

# add the Remi repo
r = yum_repository 'remi' do
  description 'Les RPM de remi pour Enterprise Linux $releasever - $basearch'
  mirrorlist 'http://rpms.famillecollet.com/enterprise/$releasever/remi/mirror'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  action :nothing
end
r.run_action(:create)

# add the Remi PHP 5.5 repo (@see webserver.rb where PHP is installed)
r =  yum_repository 'remi-php55' do
  description 'Les RPM de remi de PHP 5.5 pour Enterprise Linux $releasever - $basearch'
  mirrorlist 'http://rpms.famillecollet.com/enterprise/$releasever/php55/mirror'
  gpgkey 'http://rpms.famillecollet.com/RPM-GPG-KEY-remi'
  action :nothing
end
r.run_action(:create)

# add Nginx repo (@see webserver.rb where nginx is installed)
r =  yum_repository 'nginx' do
  description 'nginx repo'
  baseurl 'http://nginx.org/packages/centos/6/$basearch/'
  gpgkey 'http://nginx.org/keys/nginx_signing.key'
  action :nothing
end
r.run_action(:create)

#
# On some systems by default there's no swap (e.g. Digital Ocean CentOS box)
# make sure in that case we create one

swap_file '/mnt/swap' do
  size      1024    # MBs
  not_if "cat /etc/fstab | grep swap"
end
execute "echo '/mnt/swap  swap  swap  defaults  0 0' >> /etc/fstab" do
  not_if "cat /etc/fstab | grep swap"
end


#
# YUM update
#
r =  execute "yum clean all; yum update -y" do
  action :nothing
end
r.run_action(:run)

# Install development tools using yum groupinstall
execute "yum groupinstall -y 'Development tools'"

# Install extra packages (user software etc)
node[:system][:packages].each do |pkg|
  package pkg do
    action :install
  end
end


#
# Misc CentOS tuning
#

# Switch off not needed services
['abrt-ccpp', 'abrtd', 'atd', 'auditd', 'blk-availability',
  'haldaemon', 'ip6tables','iptables','kdump',
  'lvm2-monitor','mdmonitor','messagebus','postfix',
  'sysstat','udev-post','vboxadd-x11'].each do |sv|
    service sv do
      action [ :disable, :stop ]
    end
end

# Grub update: switch on verbose mode, decrease wait time
execute "sed -i 's/ rhgb quiet/ /g' /etc/grub.conf /boot/grub/grub.conf"
execute "sed -i 's/timeout=5/timeout=1/g' /etc/grub.conf /boot/grub/grub.conf"

# Tune SSH
# It speeds up login by switching off UseDNS and GSSAPIAuthentication options
service 'sshd'
sshd_config = '/etc/ssh/sshd_config'
ruby_block "speed_up_ssh_login" do
  block do
    file = Chef::Util::FileEdit.new(sshd_config)
    file.search_file_replace_line(/UseDNS/, "UseDNS no")
    file.search_file_replace_line(/GSSAPIAuthentication/, "GSSAPIAuthentication no")
    file.search_file_replace_line(/X11Forwarding/, "X11Forwarding no")
    file.insert_line_if_no_match(/Edited by VAGRANT/, '# Edited by VAGRANT')
    file.write_file
  end
  notifies :restart, "service[sshd]", :immediately
  not_if "grep VAGRANT #{sshd_config}"
end
