class profile::base (

  Array[String] $sysadmins,
  String $admingroup,
  String $sysadminplayground,
  Array[String] $stdpackages,
) {

  #sysadmin accounts
  group{ $admingroup:
    ensure => present,
  }

  #Add all the admin users specified in hiera and make sure they are in group $admingroup
  $sysadmins.each |String $account| {
    user{ $account:
      ensure => present,
      groups => $admingroup,
    }
  }

  #Make sure they have Log on as a service rights.
  local_security_policy { "Log on as a service":
    ensure       => present,
    policy_value => $admingroup,
  }

}
