exec { 'apt-get update':
  command => 'apt-get update',
  path    => '/usr/bin/',
  timeout => 60,
  tries   => 3,
}

class { 'apt':
  always_apt_update => true,
}

file { '/home/vagrant/.bash_aliases':
  ensure => 'present',
  source => 'puppet:///modules/puphpet/dot/.bash_aliases',
}

class { 'jenkins': }


package { ['git']:
  ensure  => 'installed',
  require => Exec['apt-get update'],
}

package { ['bundler']:
    ensure   => 'installed',
    provider => 'gem',
}
