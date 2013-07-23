require 'spec_helper'
require 'fuubar'
require './lib/alpaca_tags'

SPEC_ROOT = File.expand_path(File.join(File.dirname(__FILE__)))

Rspec.configure do |config|
  config.order = 'random'
end
