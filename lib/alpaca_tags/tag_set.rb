module AlpacaTags
  class TagSet
    attr_reader :tag_list

    def initialize(tag_list)
      @tag_list = tag_list
      unload!
    end

    def taglist=(tag_list)
      @tag_list = tag_list
    end

    def tags
      load
      @tags
    end

    def load
      return if @loaded

      @loaded = true
      @tag_list.each do |path|
        @tags[path] = AlpacaTags::Tags.find_or_create(path)
        @tags[path].load
      end
    end

    def load!
      @loaded = true
      @tag_list.each do |path|
        @tags[path] = AlpacaTags::Tags.find_or_create(path)
        @tags[path].load
      end
    end

    def unload!
      @loaded = false
      @tags = {}
    end
  end
end
