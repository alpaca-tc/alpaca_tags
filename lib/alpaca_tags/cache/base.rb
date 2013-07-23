module AlpacaTags::Cache
  class Base
    def initialize(file_path = nil)
      file_path ||= default_path
      @directory_path = file_path
    end

    def read(name);        raise 'Method need to override'; end
    def write(name, data); raise 'Method need to override'; end

    def caching_files
      Dir["#{default_directory}/**"]
    end

    private
    def path2string(path)
      path.gsub('/', '+=')
    end

    def default_path
      ::AlpacaTags.configuration.default_cache_path
    end

    def file_path(name)
      "#{@directory_path}/#{path2string(name)}"
    end
  end
end
