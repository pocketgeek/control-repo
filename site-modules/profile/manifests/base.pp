#
class profile::base (

  Array[String] $sysadmins,
  String $sysadmingroup,
  String $sysadminplayground,
  Array[String] $stdpackages,
  String $logonasserviceuser,
) {

  #sysadmin accounts
  group{ $sysadmingroup:
    ensure => present,
  }

  #Add all the admin users specified in hiera and make sure they are in group $sysadmingroup
  $sysadmins.each |String $account| {
    user{ $account:
      ensure  => present,
      groups  => $sysadmingroup,
      require => Group[$sysadmingroup],
    }
  }

  #Make sure logonasserviceuser user exists
  user{ $logonasserviceuser:
      ensure => present,
    }

  #Make logonasserviceuser has Log on as a service rights.
    local_security_policy { 'Log on as a service':
      ensure       => present,
      policy_value => $logonasserviceuser,
    }

  #sysadmin full access directory
  file { $sysadminplayground:
    ensure => directory,
    group  => $sysadmingroup,
  }

  #Set required rights
  $sysadmins.each |String $sysadmin| {
    acl { "${sysadminplayground}-${sysadmin}":
      target      => $sysadminplayground,
      permissions => [
        { identity => $sysadmin, rights => ['full'] },
        { identity => $sysadmingroup, rights => ['read'] }
      ],
    }
  }

  #Standard packages
    package{ $stdpackages:
      ensure   => installed,
      provider => 'chocolatey',
      notify   => Reboot['after_run'],
    }

  reboot { 'after_run':
    apply  => finished,
  }

  #Disable Internet Explorer Enhanced Security.  Once these settings are changed a log off/on is required
  #Found here: https://www.vultr.com/docs/how-to-disable-internet-explorer-enhanced-security-configuration-on-windows-server
  #because Microsoft isn't an authoritative source for Windows settings...apparently.
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\IsInstalled':
    ensure => present,
    type   => dword,
    data   => '00000001',
  }

  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}\IsInstalled': #lint:ignore:140chars 

    ensure => present,
    type   => dword,
    data   => '00000001',
  }

  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}\IsInstalled': #lint:ignore:140chars 

    ensure => present,
    type   => dword,
    data   => '00000001',
  }

  #Enable Shutdown Tracker
  registry_value { 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Reliability\ShutdownReasonOn':
    ensure => present,
    type   => dword,
    data   => '00000001',
  }

}
