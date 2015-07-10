Puppet::Type.type(:puppet_conf).provide(:cli) do

  mk_resource_methods

  def self.instances
  end

  def self.prefetch
  end

  def exists?
    @property_hash[:ensure] == :present
  end
end
