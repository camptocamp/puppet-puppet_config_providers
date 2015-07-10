require 'puppet/util/feature'

Puppet.features.add(:puppet_conf_set) do
  Puppet.version >= '3.5'
end
