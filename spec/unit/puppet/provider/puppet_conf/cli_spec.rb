require 'spec_helper'

describe Puppet::Type.type(:puppet_conf).provider(:cli) do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before :each do
        Facter.clear
        facts.each do |k, v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
        end
      end

      describe 'instances' do
        it 'should have an instance method' do
          expect(described_class).to respond_to :instances
        end
        context 'when validating instances' do
          before :each do
            described_class.expects(:puppet).with('master', '--configprint', 'all').returns \
'agent_catalog_run_lockfile = /var/lib/puppet/state/agent_catalog_run.lock
agent_disabled_lockfile = /var/lib/puppet/state/agent_disabled.lock
allow_duplicate_certs = false
allow_variables_with_dashes = false
'
          end
          it 'should return no resources' do
            expect(described_class.instances.size).to eq(4)
          end
        end
      end

      describe 'prefetch' do
        it 'should have a prefetch method' do
          expect(described_class).to respond_to :prefetch
        end
      end
    end
  end
end
