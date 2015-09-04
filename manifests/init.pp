# == Class: postfix
#
# Manage postfix configuration with Debian preseeding
#
# === Parameters
#
# [*relayhost*]
#    Set the relayhost for the machine
#
# [*main_mailer_type*]
#    Set the main mailer type as would be asked through debconf.
#    Values: 'No configuration', 'Internet Site', 'Internet with smarthost', 'Satellite system', 'Local only'
#    Default: 'Satellite system'
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
  $main_mailer_type = 'Satellite system',
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

  debconf_package {'postfix':
    ensure  => present,
    content => template('postfix/preseed.erb'),
  }
}
