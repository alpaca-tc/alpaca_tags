module AlpacaTags::Cache
  autoload :Base, 'alpaca_tags/cache/base'
  autoload :Ruby, 'alpaca_tags/cache/ruby'
  autoload :Vim, 'alpaca_tags/cache/vim'

  def self.read(name)
    cache.read(name)
  end

  def self.write(name, value)
    cache.write(name, value)
  end

  private
  def self.cache
    ::AlpacaTags.configuration.default_cache.new
  end
end
