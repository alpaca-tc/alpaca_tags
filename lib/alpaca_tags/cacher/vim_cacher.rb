require 'json'

module AlpacaTags::Cacher
  class VimCacher < AlpacaTags::Cacher::Base
    def read(name)
      File.open(file_path(name), 'r').read
    end

    def write(name, data)
      File.open(file_path(name), 'w') do |file|
        file.write data.to_json
      end
    end

    private
    def file_path(name)
      path2string("#{@directory_path}/#{name}")
    end
  end
end
