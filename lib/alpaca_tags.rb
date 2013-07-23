require 'active_support/all'

module AlpacaTags
  VERSION = '0.1'
  AUTHOR = 'alpca-tc'

  autoload :Cache, 'alpaca_tags/cache'
  autoload :Configuration, 'alpaca_tags/configuration'
  autoload :Manager, 'alpaca_tags/manager'
  autoload :TagSet, 'alpaca_tags/tag_set'
  autoload :Tags, 'alpaca_tags/tags'

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end
end
