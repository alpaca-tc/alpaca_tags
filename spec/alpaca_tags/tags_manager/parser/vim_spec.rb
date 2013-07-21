require 'spec_helper'

describe AlpacaTags::TagsManager::Parser::Vim do
  let(:line) { '' }
  subject { AlpacaTags::TagsManager::Parser::Vim.new(line) }

  describe 'ancestors' do
    it { should be_a_kind_of(AlpacaTags::TagsManager::Parser::Base) }
  end

  describe '#to_h' do
    it { pending 'We should test after implementing #to_h' }
  end
end
