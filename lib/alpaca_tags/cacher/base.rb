module AlpacaTags::Cacher
  class Base
    cattr_accessor :default_directory
    attr_accessor :directory_path

    def initialize(file_path = nil)
      file_path ||= @@default_directory
      @directory_path = file_path
    end

    def read(name);        raise 'Method need to override'; end
    def write(name, data); raise 'Method need to override'; end

    def caching_files
      DIR[@@default_directory]
    end

    def path2string(path)
      path.gsub('/', '+=')
    end
  end
end
