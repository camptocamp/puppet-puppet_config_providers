Puppet::Type.type(:puppet_conf).provide(:cli) do

  mk_resource_methods

  defaultfor :feature => :puppet_config_set
  confine :feature => :puppet_config_set

  commands :puppet => 'puppet'

  def self.instances
    puppet('config', 'print', 'all', '--section', 'main').split("\n").collect do |line|
      key, value = line.split(' = ')
      new({
        :name   => "main/#{key}",
        :ensure => :present,
        :key    => key,
        :value  => value,
      })
    end
    puppet('config', 'print', 'all', '--section', 'master').split("\n").collect do |line|
      key, value = line.split(' = ')
      new({
        :name   => "master/#{key}",
        :ensure => :present,
        :key    => key,
        :value  => value,
      })
    end
    puppet('config', 'print', 'all', '--section', 'agent').split("\n").collect do |line|
      key, value = line.split(' = ')
      new({
        :name   => "agent/#{key}",
        :ensure => :present,
        :key    => key,
        :value  => value,
      })
    end
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
  end
end
