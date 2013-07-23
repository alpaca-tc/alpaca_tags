require 'spec_helper'

describe AlpacaTags::TagSet do
  subject { AlpacaTags::TagSet }

  describe '.new' do
    let(:name) { 'name' }
    before do
      AlpacaTags::TagSet.new(name, ['path'])
    end

    it 'creats new tagset' do
      subject.tag_set[name].should be_a_kind_of(AlpacaTags::TagSet::TagList)
    end
  end
end
