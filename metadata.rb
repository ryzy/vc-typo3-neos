name             'typo3-neos'
maintainer       'Marcin Ryzycki'
maintainer_email 'marcin@ryzycki.com'
license          'GPL 2'
description      'Installs/configures TYPO3 Neos environment'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.1'

depends 'lemp-server'     # https://github.com/ryzy/vc-lemp-server
depends 'database'        # https://github.com/opscode-cookbooks/database
depends 'nginx'           # https://github.com/opscode-cookbooks/nginx
depends 'composer'        # https://github.com/escapestudios/chef-composer
