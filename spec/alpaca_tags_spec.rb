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
        c.default_cache_path = '/tmp'
        c.enable_caching = false
        # c.default_cacher = AlpacaTags::Cache::Vim
      end

      path = '/Users/taichou/project/lang-8'

      AlpacaTags::Manager.create(path, %w[~/project/lang-8/tags ~/project/lang-8/tmp/tags ~/project/lang-8/.git/bindzone.tags ~/project/lang-8/.git/tags ./tags tags;])

      path = '/Users/taichou/project/appli-frontier.com_rails_application'
      tagset = AlpacaTags::Manager.find_or_create(path, %w[~/.bundle/alpaca_tags/.git/ruby.tags ~/.bundle/alpaca_tags/.git/tags ./tags tags; ~/.bundle/alpaca_tags/.git/working_dir.tags ~/.bundle/alpaca_tags/.git/gem.tags])
      tagset.load!
      tag = tagset.tags["~/.bundle/alpaca_tags/.git/working_dir.tags"]
    end
  end
end
