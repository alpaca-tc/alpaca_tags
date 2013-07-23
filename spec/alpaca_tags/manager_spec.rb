require 'spec_helper'

describe AlpacaTags::Manager do
  let(:test_tags) { "#{SPEC_ROOT}/support/test.tags" }

  describe '.tagset_exists?' do
    it { pending 'タグセットが存在するか' }
  end

  describe '.new_tagset' do
    it { pending '新しいtag_setの作成' }
  end

  describe '.find_or_create' do
    it { pending '新しいtag_setを作成するか、探す' }
  end

  describe '.update_or_create' do
    it { pending '新しいtag_setを更新するか、探す' }
  end

  describe '.find' do
  end

  # describe '.tags' do
  #   its(:tags) { should be_a_kind_of(Array) }
  # end

  # describe '.<<' do
  #   before do
  #     tags_manager << test_tags
  #   end

  #   subject { tags_manager.tags }

  #   it { subject.first.should be_an_instance_of(AlpacaTags::Manager::Tags) }
  #   it { subject.length.should eql 1 }

  #   after do
  #     tags_manager.initialize!
  #   end
  # end
end
