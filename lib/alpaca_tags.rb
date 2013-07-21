require 'active_support/all'

module AlpacaTags
  VERSION = '0.1'
  autoload :TagsManager, 'alpaca_tags/tags_manager'
  autoload :Cacher, 'alpaca_tags/cacher'
end
