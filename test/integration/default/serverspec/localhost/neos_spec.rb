require 'spec_helper'

describe "::neos tests" do
  
  VHOST = 'neos'
  
  describe file('/etc/nginx/include-neos-rewrites.conf') do
    it { should be_file }
    its(:content) { should match /_Resources\/Persistent/ }
  end
  describe file('/etc/nginx/sites-available/'+VHOST) do
    it { should be_file }
    its(:content) { should match /server_name\s+neos/ }
  end
  # Make sure nginx can start/restart with no errors
  describe command('/etc/init.d/nginx restart') do
    it { should return_exit_status 0 }
    its(:stdout) { should match /Starting nginx.+?OK/ }
  end
  
  describe file('/var/www/'+VHOST) do
    it { should be_directory }
  end
  describe file('/var/www/'+VHOST+'/composer.lock') do
    it { should be_file }
  end
  
  # connect via curl and check responses
  [VHOST, VHOST+'.dev'].each do |url|
    describe command("curl --head http://#{url}/") do
      its(:stdout) { should match /200 OK/ }
      its(:stdout) { should match /X-Flow-Powered/ }      
    end
  end
end
