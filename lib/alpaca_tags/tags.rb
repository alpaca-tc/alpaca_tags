module AlpacaTags::Tags
  autoload :Line, 'alpaca_tags/tags/line'

  class << self
    @@cache = {}

    def find_or_create(path)
      @@cache[path] ||= Tags.new(path)
    end

    def create(path)
      @@cache[path] = Tags.new(path)
    end

    def find(path)
      @@cache[path]
    end
  end

  class Tags
    def initialize(path)
      @path = File.expand_path(path)
      @lines = []
      @loaded = false
      @remove_commented = false
    end

    def lines
      self.load unless @loaded
      @lines
    end

    def load
      load! unless @loaded
      @loaded = true
    end

    def load!
      return false unless exists?

      @lines = []
      lines = File.open(@path, 'r').read.split(/\n/)
      lines.each do |line|
        line = Line.new(line)
        line.to_h
        @lines << line unless line.is_comment?
      end

      true
    end

    def exists?
      File.exist?(@path)
    end

    def method_missing(action, *args)
      if @lines.respond_to?(action)
        @lines.send(action, *args)
      else
        super
      end
    end
  end
end
