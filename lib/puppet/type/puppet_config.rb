Puppet::Type.newtype(:puppet_config) do
  @doc = "Manages Puppet configuration."

  ensurable

  newparam(:name) do
    desc "The default namevar."
  end

  newparam(:section, :namevar => true) do
    desc "The section."
    defaultto :main
    newvalues(:main, :master, :agent)
  end

  newparam(:key, :namevar => true) do
    desc "The key."
    validate do |value|
      fail("Invalid value \"#{value}\"") unless value =~ /^\S+$/
    end
  end

  def self.title_patterns
    [
      [
        /^((\S+)\/(\S+))$/,
        [
          [ :name, lambda{|x| x} ],
          [ :section, lambda{|x| x} ],
          [ :key, lambda{|x| x} ],
        ],
      ],
      [
        /((.*))/,
        [
          [ :name, lambda{|x| x} ],
          [ :key, lambda{|x| x} ],
        ],
      ],
    ]
  end

  newproperty(:value) do
    desc "The value."
    validate do |value|
      fail("Invalid value \"#{value}\"") unless value =~ /^\S+$/
    end
  end
end
