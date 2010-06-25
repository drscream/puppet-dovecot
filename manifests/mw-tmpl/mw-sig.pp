class mw-sig {

  class c2c::mapserver inherits mapserver::debian {
    package{"libgeos-3.2.0":
      ensure => present,
    }

    Package["libgeos-3.1.0"] {
      ensure => absent,
    }

    Apt::Preferences["libgeos-3.1.0"] {
      ensure => absent,
    }

    Apt::Preferences["libgeos-c1","libgeos-dev"] {
      pin => "release o=c2c",
    }
  }

  include c2c::mapserver
  include tilecache::base
  include mapfish
  include cartoweb3::base

  apache::module {["proxy","proxy_http","proxy_ajp"]:
    ensure => present,
  }  

}