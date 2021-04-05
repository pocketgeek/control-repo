class role::monolith {

  include profile::base
  class { 'hwiis':
    websitename      => 'ponies',
    websitedirectory => 'c:\\ponies'
  }
}
