# == Class: postfix
#
# Manage postfix configuration with Debian preseeding
#
# === Parameters
#
# [*relayhost*]
#    Set the relayhost for the machine
#
# [*root_address*]
#    Set the forward address for mail sent to root.
#    Default: '' (keeping the current root alias)
#
# [*mailname*]
#    The default domain for outgoing mail
#    Default: $::fqdn
#
# [*destinations*]
#    Array of domains for whose the mail is locally delivered
#    Default: [$::fqdn]
#
# [*mynetworks*]
#    Array of networks from which to accept mail
#    Default: ['127.0.0.0/8', '[::ffff:127.0.0.0]/104', '[::1]/128'] (only accept local mail)
# === Examples
#
#  class { 'postfix':
#    relayhost => '[smtp.example.com]',
#  }
#
# === Authors
#
# Nicolas Dandrimont <nicolas@dandrimont.eu>
#
# === Copyright
#
# Copyright 2015 Nicolas Dandrimont
#
class postfix (
  $relayhost        = undef,
  $root_address     = '',
  $mailname         = $::fqdn,
  $destinations     = [$::fqdn],
  $mynetworks       = ['127.0.0.0/8', '[::ffff:127.0.0.0]/104', '[::1]/128'],
){

  validate_string($relayhost)
  validate_string($main_mailer_type)
  validate_string($root_address)
  validate_string($mailname)
  assert_type(Array[String], $destinations)
  assert_type(Array[String], $mynetworks)

  package {'postfix':
    ensure  => present,
  }

  service {'postfix':
    ensure => running,
    enable => true,
    require => [
      File['/etc/postfix/main.cf'],
      File['/etc/postfix/master.cf'],
    ],
  }

  file {'/etc/postfix/main.cf':
    ensure  => present,
    content => template('postfix/main.cf.erb'),
    notify  => Service['postfix'],
    require => Package['postfix'],
  }

  file {'/etc/postfix/master.cf':
    ensure  => present,
    content => template('postfix/master.cf.erb'),
    notify  => Service['postfix'],
    require => Package['postfix'],
  }
}
