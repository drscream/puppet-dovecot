class dovecot::params {
  if !$dovecot_version {
    case $operatingsystem {
      Debian: {
        case $lsbdistcodename {
          default: { $version = 1}
        }
      }
      Ubuntu: {
        $version = 2
      }
      default: { $version = 1 }
    }
  } else {
    $version = $dovecot_version
  }
}
