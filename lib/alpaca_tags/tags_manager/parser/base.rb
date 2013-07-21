module AlpacaTags::TagsManager::Parser
  class Base
    attr_reader :tagname, :tagfile, :tagaddress, :extensions

    def initialize(line)
      @line = line
      @extensions = []
      @to_h = { tagname: '', tagfile: '', tagadress: '', extensions: [], line: @line }
      @parsed = false
    end

    def is_comment?
      if @is_comment.nil?
        fields = @line.split(/;"/)[0..-2].join(';"').split(/\t/)
        @is_comment = true if fields.length < 3
      end

      @is_comment ||= (@line =~ /^!/).present?
    end

    %i[tagname tagfile tagaddress extensions line].each do |method|
      define_method method do
        to_h[method]
      end
    end

    def [](key)
      to_h[key]
    end

    def to_h
      return @to_h if @parsed || is_comment?
      @parsed = true

      tokens = @line.split(/;"/)

      former, extensions = if tokens.length > 1 then
                             former_value = tokens[0..-2].join(';"')
                             extensions = tokens[-1].split(/\t/).select { |v| v.present? }
                             [former_value, extensions]
                           else
                             [@line, []]
                           end

      fields = former.split(/\t/)

      @to_h[:tagname] = fields[0]
      @to_h[:tagfile] = fields[1]
      @to_h[:tagaddress] = fields[2]
      @to_h[:extensions] = extensions
      @to_h
    end
  end
end
