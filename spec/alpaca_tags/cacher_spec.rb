require 'spec_helper'

describe AlpacaTags::Cacher do
  let(:me) { AlpacaTags::Cacher }

  before do
    me.default_cacher = cacher
  end

  describe 'Instance Methods' do
    let(:name) { 'name' }
    let(:result) { 'result' }

    describe '#read' do
      let(:cacher) do
        cacher = double('cacher')
        cacher.should_receive(:read).with(name).and_return(result)
        cacher
      end

      subject { me.read(name) }

      it { should eql result }
    end

    describe '#write' do
      let(:data) { 'data' }
      let(:cacher) do
        cacher = double('cacher')
        cacher.should_receive(:write).with(name, data).and_return(true)
        cacher
      end

      subject { me.write(name, data) }

      it { should eql true }
    end
  end
end
