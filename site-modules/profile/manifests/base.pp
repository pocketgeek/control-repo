class profile::base (

  Array[String] $sysadmins,
  String $sysadmingroup,
  String $sysadminplayground,
  Array[String] $stdpackages,
) {

  #sysadmin accounts
  group{ $sysadmingroup:
    ensure => present,
  }

  #Add all the admin users specified in hiera and make sure they are in group $sysadmingroup
  $sysadmins.each |String $account| {
    user{ $account:
      ensure => present,
      groups => $sysadmingroup,
      require => Group[$sysadmingroup],
    }
  }

  #Make sure they have Log on as a service rights.
  local_security_policy { "Log on as a service":
    ensure       => present,
    policy_value => $sysadmingroup,
  }

}
