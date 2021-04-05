class role::monolith {

  include profile::base
  hwiis{ 'ponies':
    websitename      => 'ponies',
    websitedirectory => 'c:\\ponies'
  }
}
