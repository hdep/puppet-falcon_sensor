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
# [*cid*]
#  String, Customer Identification Code provided from crowdstrike.
#  Default : undef
#
# [*download_package*]
# Boolean. If set to true this will download the deb package from provided URL in $package_url
# usefull when you don't have a deb repository
# Default : false
#
# [*download_dir*]
# String. Directory where to put the download deb file.
#
# [*package_url*]
# Optional http url where to download the .deb file.
# 
# [*package_filename*]
# Package name on the system.
#
# [*proxy_url*]
# proxy DNS name only. Like proxy.domain.fr
# If set it is used for downloading the archive and reaching Crowdstrike servers.
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
  $cid          = Undef,
  Boolean $download_package          = false,
  String $download_dir               = '/usr/local/src',
  Optional[String] $package_url      = undef,
  Optional[String] $package_filename = 'falcon-sensor',
  Optional[String] $proxy_url        = undef,
  Integer $proxy_port                = 3128,
  String $proxy_type                 = 'http',
  Optional[String] $tag              = undef,
) {

  validate_re($ensure, ['^present|absent',])

  if $falcon_sensor::download_package {
    archive { "${falcon_sensor::download_dir}/${falcon_sensor::package_filename}":
      ensure       => present,
      source       => $falcon_sensor::package_url,
      proxy_server => "${falcon_sensor::proxy_type}${falcon_sensor::proxy_url}:${falcon_sensor::proxy_port}",
    }

    $provider = $facts['os']['name'] ? {
      'RedHat' => rpm,
      'CentOS' => rpm,
      'Debian' => dpkg
    }

    $dependency = $::operatingsystem ? {
      Debian => 'libnl-genl-3-200',
      default => 'libnl'
    }

    package { 'libnl':
      ensure => $ensure,
      name   => $dependency,
    }

    package { $package_name:
      ensure   => $ensure,
      source   => "/tmp/${qualys_agent::package_filename}",
      name     => $falcon_sensor::package_name,
      provider => $provider,
      require  => Archive["${falcon_sensor::download_dir}/${falcon_sensor::package_name}"],
    }
  }
  else {
      if $ensure == 'present' and $autoupgrade {
        $package_ensure = 'latest'
      } else {
        $package_ensure = $ensure
      }

      package { $package_name:
        ensure => $package_ensure,
      }
  }

  service { 'falcon-sensor':
    ensure  => true,
    require => Package[$package_name],
  }

  if $falcon_sensor::proxyname {
    if $falcon_sensor::tags {
      exec { 'configure_falcon_sensor_with_proxy_and_tag':
        command => "/opt/CrowdStrike/falconctl -s -f --cid=${falcon_sensor::cid} --tags=${falcon_sensor::tag} \
         --aph=${falcon_sensor::proxy_url} --app=${falcon_sensor::proxy_port}",
        onlyif  => [
          '/opt/CrowdStrike/falconctl -g --cid ; if [ $? -eq 0 ]; then exit 1 ; else exit 0 ; fi'
        ],
        require => Package[$package_name],
      }
    }
    else {
      exec { 'configure_falcon_sensor_with_proxy_without_tag':
        command => "/opt/CrowdStrike/falconctl -s -f --cid=${falcon_sensor::cid} --aph=${falcon_sensor::proxy_url} \
        --app=${falcon_sensor::proxy_port}",
        onlyif  => [
          '/opt/CrowdStrike/falconctl -g --cid ; if [ $? -eq 0 ]; then exit 1 ; else exit 0 ; fi'
        ],
        require => Package[$package_name],
      }
    }
  }
  else {
    if $tag {
      exec { 'configure_falcon_sensor_without_proxy':
        command => "/opt/CrowdStrike/falconctl -s -f --cid=${falcon_sensor::cid} --tags=${falcon_sensor::tag}",
        onlyif  => [
          '/opt/CrowdStrike/falconctl -g --cid ; if [ $? -eq 0 ]; then exit 1 ; else exit 0 ; fi'
        ],
        require => Package[$package_name],
      }
    }
    else {
      exec { 'configure_falcon_sensor_without_proxy_tag':
        command => "/opt/CrowdStrike/falconctl -s -f --cid=${falcon_sensor::cid}",
        onlyif  => [
          '/opt/CrowdStrike/falconctl -g --cid ; if [ $? -eq 0 ]; then exit 1 ; else exit 0 ; fi'
        ],
        require => Package[$package_name],
      }
    }
  }
}
