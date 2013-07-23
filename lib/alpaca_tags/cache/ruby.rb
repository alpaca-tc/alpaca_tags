module AlpacaTags::Cache
  class Ruby < AlpacaTags::Cache::Base
    def read(name)
      data = nil
      File.open(file_path(name), 'r') do |file|
        data = file.read
      end

      -> {
        $SAFE = 4
        eval(data)
      }.call
    end

    def write(name, data)
      File.open(file_path(name), 'w') do |file|
        file.write data
      end
    end
  end
end
