module AlpacaTags::TagParser
  class Base
    def initialize(path)
      @path = path
    end

    def self.is_suitable_parser?(path); raise 'Not implemented'; end
    def load; raise 'Not implemented'; end

    protected
    def exists?
      File.exists?(@path)
    end
  end
end
