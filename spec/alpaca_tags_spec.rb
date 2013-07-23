require 'spec_helper'

describe AlpacaTags do
  describe '#VERSION' do
    subject { AlpacaTags::VERSION }
    it { should eql('0.1') }
  end
end

describe AlpacaTags do
  describe 'hoge' do
    it 'hoge' do
      AlpacaTags.configure do |c|
        c.default_cache_path = '/Users/alpaca/.vim.trash/unite/alpaca_tags'
        c.enable_caching = false
        c.default_cache = ::AlpacaTags::Cache::Vim
        c.default_tag_parser = ::AlpacaTags::TagFile::TagParser::CacheAsVimObject
        # c.default_cacher = AlpacaTags::Cache::Vim
      end

      tags = %w[~/project/lang-8/tags ~/project/lang-8/tmp/tags ~/project/lang-8/.git/ruby.tags ~/project/lang-8/.git/tags ./tags tags; ~/project/lang-8/.git/working_dir.tags ~/project/lang-8/.git/gem.tags]
      tag_set = AlpacaTags::Manager.create('~/project/lang-8', tags)
      tag_list = tag_set.to_a
      tag = tag_list.first
      binding.pry;
    end
  end
end
