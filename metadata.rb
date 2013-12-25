name             'vc-typo3'
maintainer       'ryzy'
maintainer_email 'marcin@ryzycki.com'
license          'All rights reserved'
description      'Installs/Configures vc-typo3'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'build-essential'
depends 'yum'
depends 'mysql'
depends 'database'
depends 'php', '~> 1.2.0'
depends 'nginx'
