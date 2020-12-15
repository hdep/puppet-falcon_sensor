[![Build Status](https://travis-ci.org/hdep/puppet-falcon_sensor.svg?branch=master)](https://travis-ci.org/hdep/puppet-falcon_sensor)
# falcon_sensor

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with falcon_sensor](#setup)
    * [What falcon_sensor affects](#what-falcon_sensor-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with falcon_sensor](#beginning-with-falcon_sensor)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Crowdstrike's Falcon sensor is a host based IDS. This module just installs the RPM,
primarily on EL6 and EL7.

## Module Description

There isn't a whole lot to this module. Currently their RPM does a bunch of things
we wish it didn't. Maybe one day this module will do those instead.

## Setup

### Setup Requirements

Crowdstrike doesn't have a repo.  You need to make their package available to
your systems via a yum repository.

## Usage

Nothing to do right now.

## Reference

* Class: falcon_sensor

## Limitations

* EL 6
* EL 7

## Development

Main request: Pass the tests, include new ones if relevant.

