module AlpacaTags::TagsManager
  module Caching
    @@cache = {}

    def self.new(path)
      @@cache[path] ||= ::AlpacaTags::TagsManager::Tags.new(path)
    end
  end

  class Tags
    attr_reader :path, :lines
    cattr_accessor :default_parser
    @@default_parser ||= AlpacaTags::TagsManager::Parser::Base

    def initialize(path, parser = @@default_parser)
      @path = path
      @lines = []
      @loaded = false
      @remove_commented = false
      @parser = parser
    end

    def load
      reload! unless @loaded
      @loaded = true
    end

    def reload!
      @lines = []
      lines = File.open(@path, 'r').read.split(/\n/)
      lines.each do |line|
        @lines << @parser.new(line)
      end

      true
    end

    def lines
      self.load unless @loaded
      @lines
    end

    def remove_comment!
      unless @remove_commented
        @remove_commented = true
        @lines = lines.delete_if { |line| line.is_comment? }
      end

      lines
    end

    def to_a
      lines.each_with_object([]) do |line, result|
        result << line.to_h
      end
    end

    def method_missing(action, *args)
      self.load

      if @lines.respond_to?(action)
        lines.send(action, *args) 
      else
        super
      end
    end
  end
end
