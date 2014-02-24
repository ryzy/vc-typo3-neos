require 'serverspec'
require 'pathname'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.os = backend(Serverspec::Commands::Base).check_os
    
    c.path = [
      '/usr/local/sbin', '/usr/local/bin',
      '/sbin', '/bin',
      '/usr/sbin', '/usr/bin',
      '/opt/rubies/2.0.0-p353/bin',
    ].join(':')
    
  end
end
