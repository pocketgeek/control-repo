class profile::iis_ponies {

  $websitename = 'ponies'
  $websitedirectory = 'c:\\ponies'

#Build website
  iis_site { $websitename:
    ensure          => 'started',
    physicalpath    => $websitedirectory,
    applicationpool => 'DefaultAppPool',
    require         => [
      File[ $websitedirectory ],
      Iis_site['Default Web Site']
    ],
  }

  #Make sure the website base directory exsits and no extra stuff is in it
  file { $websitedirectory:
    ensure  => directory,
    purge   => true,
    recurse => true,
    source  => 'puppet:///modules/hwiis/empty',
  }

  #Website content.
  file { "${websitedirectory}\\pony.jpeg":
    ensure => 'present',
    source => 'puppet:///modules/hwiis/pony.jpeg',
  }

  #Website content
  file { "${websitedirectory}\\default.htm":
    ensure => 'present',
    source => 'puppet:///modules/hwiis/default.htm',
  }
}
