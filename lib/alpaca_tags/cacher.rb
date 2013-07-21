module AlpacaTags::Cacher
  autoload :Base, 'alpaca_tags/cacher/base'
  autoload :VimCacher, 'alpaca_tags/cacher/vim_cacher'

  mattr_accessor :default_cacher

  def self.read(name)
    @@default_cacher.read(name)
  end

  def self.write(name, value)
    @@default_cacher.write(name, value)
  end
end
