module AlpacaTags::Manager
  class << self
    @@tagset_list = {}

    def tagset_exists?(path)
      @@tagset_list.has_key(path)
    end

    def create(name, taglist = [])
      @@tagset_list[resolve_name(name)] = ::AlpacaTags::TagSet.new(taglist)
    end

    def find_or_create(name, taglist = [])
      @@tagset_list[resolve_name(name)] ||= ::AlpacaTags::TagSet.new(taglist)
    end

    def create_or_update(name, taglist = [])
      @@tagset_list[resolve_name(name)] = ::AlpacaTags::TagSet.new(taglist)
    end

    def find(name)
      @@tagset_list[resolve_name(name)]
    end

    private
    def resolve_name(name)
      File.expand_path(name)
    end
  end
end
