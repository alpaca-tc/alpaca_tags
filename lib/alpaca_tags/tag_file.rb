module AlpacaTags::TagFile
  class << self
    @@cache = {}

    def find_or_create(path)
      @@cache[path] ||= Tag.new(path)
    end

    def create(path)
      @@cache[path] = Tag.new(path)
    end

    def find(path)
      @@cache[path]
    end
  end

  class Tag
    attr_accessor :path, :parser, :tags

    def initialize(path, parser = nil)
      parser ||= AlpacaTags.configuration.default_tag_parser
      @path = File.expand_path(path)
      @loaded = false
      @parser = parser.new(@path)
      @tags = []
    end

    def exists?
      File.exist?(@path)
    end

    def load
      @tags = @parser.load unless @loaded
      @loaded = true
    end

    def load!
      unload!
      load
    end

    def unload!
      @loaded = false
      @tags = []
    end
  end
end
