module AlpacaTags::Cacher
  autoload :Base, 'alpaca_tags/cacher/base'
  autoload :Vim, 'alpaca_tags/cacher/vim'

  mattr_accessor :default_cacher

  def self.read(name)
    @@default_cacher.read(name)
  end

  def self.write(name, value)
    @@default_cacher.write(name, value)
  end
end
