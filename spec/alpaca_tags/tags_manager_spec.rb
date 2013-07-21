require 'spec_helper'

describe AlpacaTags::TagsManager do
  let(:tags_manager) { AlpacaTags::TagsManager }
  let(:test_tags) { "#{root}/spec/support/test.tags" }
  let(:root) { File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..')) }

  describe '.tags' do
    its(:tags) { should be_a_kind_of(Array) }
  end

  describe '.<<' do
    before do
      tags_manager << test_tags
    end

    subject { tags_manager.tags }

    it { subject.first.should be_an_instance_of(AlpacaTags::TagsManager::Tags) }
    it { subject.length.should eql 1 }

    after do
      tags_manager.initialize!
    end
  end
end
