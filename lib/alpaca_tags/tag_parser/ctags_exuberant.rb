module AlpacaTags::TagParser
  class CtagsExuberant < Base
    def self.is_suitable_parser?(path)
      true
    end

    def load
      return [] unless exists?

      lines = File.open(@path).read.strip.split(/$/)
      lines.each_with_object([]) do |line, tags|
        next if line.match(/^!/)
        parsed = parse(line) 
        tags << parsed if parsed
      end
    end

    private
    def parse(line)
      line.strip!

      # 1.
      tokens = line.split(';"')
      former, extensions = if tokens.length > 1
                             former = tokens[0..-2].join(';"')
                             extensions = tokens[-1].split("\t").select { |v| !v.empty? }
                             [former, extensions]
                           else
                             [line, []]
                           end

      # 2.
      fields = former.split("\t")
      if fields.length < 3
        return nil
      end

      # 3.
      name = fields.shift
      file = fields.shift
      address = fields.join("\t")

      # 4. TODO
      { 
        tagname: name, 
        tagfile: file, 
        tagaddress: address, 
        tagfield: extensions 
      }
    end
  end
end
