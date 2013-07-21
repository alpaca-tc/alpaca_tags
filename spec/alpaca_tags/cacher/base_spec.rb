require 'spec_helper'

describe AlpacaTags::Cacher::Base do
  describe 'Instance Methods' do
    subject { AlpacaTags::Cacher::Base.new }

    it { should be_respond_to(:read) }
    it { should be_respond_to(:write) }
  end
end
