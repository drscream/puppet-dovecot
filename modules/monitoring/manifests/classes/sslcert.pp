class monitoring::sslcert {

  include monitoring::params

  $rev  = "1144" # svn revision number, increment after testing.
  $repo = "https://trac.id.ethz.ch/projects/nagios_plugins"
  $url  = "${repo}/export/${rev}/check_ssl_cert/check_ssl_cert"

  #TODO: use vcsrepo
  exec { "download check_ssl_cert":
    command => "curl -o ${monitoring::params::customplugins}/check_ssl_cert-r${rev} ${url}",
    creates => "${monitoring::params::customplugins}/check_ssl_cert-r${rev}",
    require => [File["${monitoring::params::customplugins}"], Package["curl"]],
  }

  file { "${monitoring::params::customplugins}/check_ssl_cert-r${rev}":
    owner   => "root",
    mode    => 0755,
    require => Exec["download check_ssl_cert"],
  }

  file { "${monitoring::params::customplugins}/check_ssl_cert":
    ensure  => link,
    target  => "${monitoring::params::customplugins}/check_ssl_cert-r${rev}",
    require => File["${monitoring::params::customplugins}/check_ssl_cert-r${rev}"],
  }

}

/*

== Definition: monitoring::check::sslcert

A small wrapper around monitoring::check.

Not included in monitoring::sslcert because we could need to check more than
one certificate per host.

*/
define monitoring::check::sslcert (
  $ensure="present",
  $certname=undef,
  $host="localhost", # check local certificate by default
  $org=$sslcert_organisation, # see apache::base::ssl
  $rootcrt="",
  $port="443",
  $days="45") {

  if ($rootcrt == "") {
    $crtfile = $operatingsystem ? {
      Debian => "/etc/ssl/certs/ca-certificates.crt",
      /RedHat|CentOS/ => "/etc/pki/tls/certs/ca-bundle.crt",
    }
  } else {
    $crtfile = $rootcrt
  }

  if (!$certname) {
    $_certname = $name
  } else {
    $_certname = $certname
  }

  monitoring::check { "SSL Cert: $_certname:$port":
    codename => "check_ssl_cert_${_certname}_${port}",
    command  => "check_ssl_cert",
    interval => "720", # 2x/day
    base     => "${monitoring::params::customplugins}",
    options  => "-H ${host} -n ${_certname} -p ${port} -r ${crtfile} -d ${days} -o '${org}'",
    type     => "passive",
    server   => $nagios_nsca_server,
  }

}
