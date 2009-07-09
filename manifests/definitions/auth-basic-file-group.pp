define apache::auth::basic::file::group (
  $ensure="present", 
  $authname="Private Area",
  $vhost,
  $location="/",
  $authUserFile=false,
  $authGroupFile=false,
  $groups){
 
  if defined(Apache::Module["authn_file"]) {} else {
    apache::module {"authn_file": }
  }

  if $authUserFile {
    $_authUserFile = $authUserFile
  } else {
    $_authUserFile = "/var/www/${vhost}/private/htpasswd"
  }

  if $authGroupFile {
    $_authGroupFile = $authGroupFile
  } else {
    $_authGroupFile = "/var/www/${vhost}/private/htgroup"
  }

  file {"/var/www/${vhost}/conf/auth-basic-file-group-${name}.conf":
    ensure => $ensure,
    content => template("apache/auth-basic-file-group.erb"),
    notify => Exec["apache-graceful"],
  }

}
