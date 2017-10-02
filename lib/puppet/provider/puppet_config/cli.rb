require 'puppet/face'

Puppet::Type.type(:puppet_config).provide(:cli) do

  mk_resource_methods

  defaultfor :feature => :puppet_config_set
  confine :feature => :puppet_config_set

  if Facter.value(:rubysitedir) =~ /puppetlabs/
    commands :puppet => '/opt/puppetlabs/bin/puppet'
  else
    commands :puppet => '/usr/bin/puppet'
  end

  def self.instances
    main_config = puppet('config', 'print', 'all', '--section', 'main').split("\n").collect do |line|
      key, value = line.split(' = ')
      new({
        :name   => "main/#{key}",
        :ensure => :present,
        :key    => key,
        :value  => value,
      })
    end
    master_config = puppet('config', 'print', 'all', '--section', 'master').split("\n").collect do |line|
      key, value = line.split(' = ')
      new({
        :name   => "master/#{key}",
        :ensure => :present,
        :key    => key,
        :value  => value,
      })
    end
    agent_config = puppet('config', 'print', 'all', '--section', 'agent').split("\n").collect do |line|
      key, value = line.split(' = ')
      new({
        :name   => "agent/#{key}",
        :ensure => :present,
        :key    => key,
        :value  => value,
      })
    end
    [ main_config, master_config, agent_config].flatten
  end

  def self.prefetch(resources)
    items = instances
    resources.keys.each do |name|
      if provider = items.find{ |pkg| pkg.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    Puppet::Error 'You should not have to create new entries'
  end

  def value=(value)
    puppet('config', 'set', resource[:key], value, '--section', resource[:section])
    @property_hash[:value] = value
  end
end
