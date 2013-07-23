module AlpacaTags
  class TagSet
    attr_reader :tag_list

    def initialize(tag_list)
      @tag_list = tag_list
    end

    def load
      return if @loaded

      get_tag_list
      @tags.each { |k, v| v.load }
    end

    def load!
      get_tag_list
      @tags.each { |k, v| v.load! }
    end

    def unload!
      @loaded = false
      @tag_array = nil
      @tags = {}
    end

    def to_a(only_exist_file = true)
      load
      @tag_array ||= @tags.values
      return @tag_array unless only_exist_file

      @tag_array.select { |v| v.exists? }
    end

    def to_h(only_exist_file = true)
      load
      if only_exist_file
        @tags.select { |k, v| v.exists? }
      else
        @tags
      end
    end

    private
    def get_tag_list
      unload!
      @loaded = true
      @tag_list.each do |path|
        @tags[path] = AlpacaTags::TagFile.find_or_create(path)
      end
    end
  end
end
