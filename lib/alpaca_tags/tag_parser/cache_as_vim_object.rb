module AlpacaTags::TagParser
  class CacheAsVimObject < CtagsExuberant
    def load
      return [] unless exists?
      return AlpacaTags::Cache.read(@path) if AlpacaTags::Cache.exists?(@path)

      parsed = super
      AlpacaTags::Cache.write(@path, parsed)

      parsed
    end

    private
    def parse(line)
      parsed = super(line)
      return unless parsed

      {
        word: parsed[:tagname],
        abbr: "#{parsed[:tagname]} #{parsed[:tagfile]} #{parsed[:tagaddress]}",
        kind: 'file',
        action__path: parsed[:tagfile],
        action__directory: File.dirname(parsed[:tagfile]),
      }
    end
  end
end
