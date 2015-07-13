Puppet_config_providers
=======================

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/camptocamp/puppet_config_providers.svg)](https://forge.puppetlabs.com/camptocamp/puppet_config_providers)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/camptocamp/puppet_config_providers.svg)](https://forge.puppetlabs.com/camptocamp/puppet_config_providers)
[![Build Status](https://img.shields.io/travis/camptocamp/puppet-puppet_config_providers/master.svg)](https://travis-ci.org/camptocamp/puppet-puppet_config_providers)
[![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/camptocamp/puppet_config_providers.svg)](https://forge.puppetlabs.com/camptocamp/puppet_config_providers)
[![Gemnasium](https://img.shields.io/gemnasium/camptocamp/puppet-puppet_config_providers.svg)](https://gemnasium.com/camptocamp/puppet-puppet_config_providers)
[![By Camptocamp](https://img.shields.io/badge/by-camptocamp-fb7047.svg)](http://www.camptocamp.com)

Puppet custom Type and Providers to manage puppet.conf

Only work with puppet 3.5+ for the moment

Usage
-----

```puppet
puppet_config { 'master/parser':
  value => 'future',
}
```

or

```puppet
puppet_config { 'parser':
  section => 'master',
  value   => 'future',
}
```
