module AlpacaTags::TagsManager
  autoload :Tags, 'alpaca_tags/tags_manager/tags'
  autoload :Parser, 'alpaca_tags/tags_manager/parser'

  mattr_accessor :tags

  def self.tags
    @@tags ||= []
  end

  def self.<<(tag_file_path)
    tags
    @@tags << Tags::Caching.new(tag_file_path)
    @@tags.uniq!
  end

  def self.initialize!
    @@tags = []
  end

  def self.reload!
    @@tags.each { |tags| tags.reload! }
  end
end
