Puppet::Type.type(:puppet_conf).provide(:cli) do

  mk_resource_methods

  commands :puppet => 'puppet'

  def self.instances
    puppet('master', '--configprint', 'all').split("\n").collect do |line|
      key, value = line.split(' = ')
      new({
        :name   => "master/#{key}",
        :ensure => :present,
        :key    => key,
        :value  => value,
      })
    end
  end

  def self.prefetch
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
end
