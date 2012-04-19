/*

= Class dovecot::ubuntu
Inherits dovecot::base, and set variables according to ubuntu standards

Please do not include this class, it's better to "include dovecot".

*/
class dovecot::ubuntu inherits dovecot::base {

  Package["Dovecot"] {
    name => "dovecot-common",
  }

  Package["Dovecot IMAP"] {
    name => "dovecot-imapd",
  }

  Package["Dovecot POP3"] {
    name => "dovecot-pop3d",
  }

  Service["dovecot"] {
    pattern => "dovecot",
  }

}
