require 'spec_helper'

describe AlpacaTags do
  describe '#VERSION' do
    subject { AlpacaTags::VERSION }
    it { should eql('0.1') }
  end
end
