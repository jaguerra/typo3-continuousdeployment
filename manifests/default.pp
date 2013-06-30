
exec { 'apt-get update':
  command => 'apt-get update',
  path    => '/usr/bin/',
  timeout => 60,
  tries   => 3,
}

class { 'apt':
  always_apt_update => true,
}

package { ['python-software-properties']:
  ensure  => 'installed',
  require => Exec['apt-get update'],
}

file { '/home/vagrant/.bash_aliases':
  ensure => 'present',
  source => 'puppet:///modules/puphpet/dot/.bash_aliases',
}

package { ['build-essential', 'vim', 'curl', 'unzip']:
  ensure  => 'installed',
  require => Exec['apt-get update'],
}

class { 'apache': }

apache::dotconf { 'custom':
  content => 'EnableSendfile Off',
}

apache::module { 'rewrite': }

group { 'web': 
	ensure => "present"
}

user { 'vagrant':
		ensure => "present",
		groups      => ["web"],
		membership => minimum,
		require => Group['web']
}

user { 'www-data': 
	ensure => "present",
	groups      => ["web"],
	membership => minimum,
	require => Group['web']
}


#$app_dirs = [ "/var/www/", "/var/www/current", "/var/www/current/htdocs"]
$app_dirs = [ "/var/www/"]

file { $app_dirs:
    ensure => "directory",
    owner  => "vagrant",
    group  => "web",
    mode   => 2777,
    require => Group['web']
}


apache::vhost { 'awesome.dev':
  server_name   => 'awesome.dev',
  serveraliases => [],
  docroot       => '/var/www/current/htdocs/',
  port          => '80',
  env_variables => [],
  priority      => '1',
}

apt::ppa { 'ppa:ondrej/php5':
  before  => Class['php'],
}

class { 'php':
  service => 'apache',
  require => Package['apache'],
}

php::module { 'php5-cli': }
php::module { 'php5-curl': }
php::module { 'php5-gd': }
php::module { 'php5-intl': }
php::module { 'php5-mcrypt': }
php::module { 'php5-xcache': }
php::module { 'php5-mysql': }

class { 'php::devel':
  require => Class['php'],
}

class { 'php::pear':
  require => Class['php'],
}



class { 'xdebug':
  service => 'apache',
}

xdebug::config { 'cgi':
  remote_autostart => '0',
  remote_port      => '9000',
}
xdebug::config { 'cli':
  remote_autostart => '0',
  remote_port      => '9000',
}

php::pecl::module { 'xhprof':
  use_package => false,
}

apache::vhost { 'xhprof':
  server_name => 'xhprof',
  docroot     => '/var/www/xhprof/xhprof_html',
  port        => 80,
  priority    => '1',
  require     => Php::Pecl::Module['xhprof']
}


class { 'php::composer': }

php::ini { 'php':
  value   => ['date.timezone = "Europe/Madrid"'],
  target  => 'php.ini',
  service => 'apache',
}
php::ini { 'custom':
  value   => ['display_errors = On', 'error_reporting = -1'],
  target  => 'custom.ini',
  service => 'apache',
}

php::ini { 'typo3':
  value   => ['upload_max_filesize = 10M', 'max_execution_time = 240', 'xdebug.max_nesting_level = 500', 'xdebug.default_enable = off', 'post_max_size=10M'],
  target  => 'typo3.ini',
  service => 'apache',
}

class { "mysql":
    root_password => 'root',
}

mysql::grant { 'typo3deploy':
    mysql_privileges => 'ALL',
    mysql_password => 'typo3deploy',
    mysql_db => 'typo3deploy',
    mysql_user => 'typo3deploy',
    mysql_host => 'localhost',
}


