class profile::iis_base {
  #IIS and required features
  $iis_features = ['Web-WebServer','Web-Scripting-Tools']

  #Make sure IIS and required features are installed
  iis_feature { $iis_features:
    ensure => 'present',
  }

  # Delete the default website to prevent a port binding conflict.
  # And because it's terrible and should feel bad.
  iis_site {'Default Web Site':
    ensure  => absent,
    require => Iis_feature['Web-WebServer'],
  }
}
