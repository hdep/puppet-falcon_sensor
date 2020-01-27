# Class: falcon_sensor
# ====================
#
# This module ensures the installation and enabling of CrowdStrike's Falcon
# sensor.
#
# This module does not:
#   * Ensure audit is enabled in your kernel
#   * Configure your local firewall's egress rules to access the SaaS
#
#
# Parameters
# ----------
#
# [*ensure*]
#   String. State of the module.
#   Default: present
#
# [*package_name*]
#   String.
#   Default: falcon-sensor
#
# [*autoupgrade*]
#   Boolean. If set to true the package gets upgraded on each Puppet run
#   when the package provider finds a new version available. Exact behavior
#   is provider dependent.
#   Default: false
#
# Examples
# --------
#
# @example
#    class { 'falcon_sensor': }
#
# Authors
# -------
#
# Greg Swift <greg.swift@rackspace.com>
#
# Copyright
# ---------
#
# Copyright 2016 Rackspace
#
class falcon_sensor (
  $ensure       = 'present',
  $package_name = 'falcon-sensor',
  $autoupgrade  = false,
  $cid          = Undef
) {

  validate_re($ensure, ['^present|absent',])

  if $ensure == 'present' and $autoupgrade {
    $package_ensure = 'latest'
  } else {
    $package_ensure = $ensure
  }

  package { $package_name:
    ensure => $package_ensure,
  }

  if $cid and $facts['falcon_sensor']['cid'] != $cid {
    exec { 'configure_falcon_sensor':
      command => "falconctl -s --cid ${cid}"
    }
  }

}
