require 'spec_helper'

describe AlpacaTags::Manager::Parser do
  let(:line) { %Q!#{tagname}	#{tagfile}	#{tagaddress};"	#{extensions}! }
  let(:tagname) { 'method' }
  let(:tagfile) { '/Users/stub/path/test_spec.rb' }
  let(:tagaddress) { %Q!/^    def #{tagname}$/! }
  let(:extensions) { 'f' }
  let(:instance) { AlpacaTags::Manager::Parser::Base.new(line) }

  subject { instance }

  describe 'InstanceMethods' do
    describe '#is_comment?' do
      subject { instance.is_comment? }
      context 'when instance is initialized with comment line' do
        let(:line) { '!comment line' }
        it { should be_true }
      end

      context 'when instance is initialized with normal line' do
        it { should be_false }
      end

      context 'when instance is initialized with short line' do
        let(:line) { "\td" }
        it { should be_true }
      end
    end

    describe '#[]' do
      subject { instance[:tagname] }
      it { should eql(tagname) }
    end

    describe '#tagname' do
      its(:tagname) { should eql tagname }
    end

    describe '#tagfile' do
      its(:tagfile) { should eql tagfile }
    end

    describe '#tagaddress' do
      its(:tagaddress) { should eql tagaddress }
    end

    describe '#extensions' do
      its(:extensions) { should eql [extensions] }
      its(:extensions) { should be_an_instance_of(Array) }
    end
  end

end
