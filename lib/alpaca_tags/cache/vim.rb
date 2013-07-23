require 'json'

module AlpacaTags::Cache
  class Vim < AlpacaTags::Cache::Base
    def read(name)
      file = File.open(file_path(name), 'r')
      data = file.read
      file.close
      
      -> {
        $SAFE = 4
        data.present? ? JSON.parse(data) : {} 
      }.call
    end

    def write(name, data)
      File.open(file_path(name), 'w') do |file|
        file.write data.to_json
      end
    end
  end
end
