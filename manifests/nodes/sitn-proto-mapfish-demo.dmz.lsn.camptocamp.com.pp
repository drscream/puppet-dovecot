node "sitn-proto-mapfish-demo.dmz.lsn.camptocamp.com" {
  $postgresql_version = "8.4"
  $apache_vhost_name = $fqdn
  include srv-c2c-sig-demo

}
