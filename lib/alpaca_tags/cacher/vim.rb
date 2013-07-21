require 'json'

module AlpacaTags::Cacher
  class Vim < AlpacaTags::Cacher::Base
    def read(name)
      file = File.open(file_path(name), 'r')
      data = file.read
      file.close
      
      data.present? ? JSON.parse(data) : {} 
    end

    def write(name, data)
      File.open(file_path(name), 'w') do |file|
        file.write data.to_json
      end
    end

    private
    def file_path(name)
      "#{directory_path}/#{path2string(name)}"
    end
  end
end
