require 'spec_helper'

describe Puppet::Type.type(:puppet_config) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before :each do
        Facter.clear
        facts.each do |k, v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
        end
      end

      describe 'when validating attributes' do
        [ :name, :section, :key ].each do |param|
          it "should have a #{param} parameter" do
            expect(described_class.attrtype(param)).to eq(:param)
          end
        end
        [ :ensure, :value ].each do |prop|
          it "should have a #{prop} property" do
            expect(described_class.attrtype(prop)).to eq(:property)
          end
        end
      end

      describe "namevar validation" do
        it "should have :name, :section and :key as its namevar" do
          expect(described_class.key_attributes).to eq([:name, :section, :key])
        end
      end

      describe 'when validating attribute values' do
        describe 'ensure' do
          [ :present, :absent ].each do |value|
            it "should support #{value} as a value to ensure" do
              expect { described_class.new({
                :name   => 'foo',
                :ensure => value,
              })}.to_not raise_error
            end
          end

          it "should not support other values" do
            expect { described_class.new({
              :name   => 'foo',
              :ensure => 'bar',
            })}.to raise_error(Puppet::Error, /Invalid value/)
          end
        end

        describe 'section' do
          [ 'main', 'master', 'agent' ].each do |value|
            it "should support #{value} as a value to ensure" do
              expect { described_class.new({
                :name    => 'foo',
                :section => value,
              })}.to_not raise_error
            end
          end

          it "should not support other values" do
            expect { described_class.new({
              :name    => 'foo',
              :section => 'bar',
            })}.to raise_error(Puppet::Error, /Invalid value "bar"/)
          end
        end

        describe 'key' do
          [ 'vardir', 'libdir' ].each do |value|
            it "should support #{value} as a value to ensure" do
              expect { described_class.new({
                :name => 'foo',
                :key  => value,
              })}.to_not raise_error
            end
          end

          it "should not support empty value" do
            expect { described_class.new({
              :name => 'foo',
              :key  => '',
            })}.to raise_error(Puppet::Error, /Invalid value/)
          end

          it "should not support spaces" do
            expect { described_class.new({
              :name => 'foo',
              :key  => 'bar baz',
            })}.to raise_error(Puppet::Error, /Invalid value/)
          end
        end

        describe 'value' do
          [ 'foo', 'bar' ].each do |value|
            it "should support #{value} as a value to ensure" do
              expect { described_class.new({
                :name  => 'foo',
                :value => value,
              })}.to_not raise_error
            end
          end

          it "should not support empty value" do
            expect { described_class.new({
              :name  => 'foo',
              :value => '',
            })}.to raise_error(Puppet::Error, /Invalid value/)
          end

          it "should not support spaces" do
            expect { described_class.new({
              :name  => 'foo',
              :value => 'bar baz',
            })}.to raise_error(Puppet::Error, /Invalid value/)
          end
        end
      end
    end
  end
end
