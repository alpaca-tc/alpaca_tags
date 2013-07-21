require 'json'

module VIM
  class << self
    def encode
      evaluate('&encoding')
    end

    def let(name, value)
      parsed = value.to_json.to_s.force_encoding(encode)
      command("let #{name} = #{parsed}")
    end

    def get(name)
      value = evaluate(name)
      if value.is_a? String
        value.force_encoding(encode) 
      else
        value
      end
    end

    def debug(name_or_message, message = nil)
      name = message ? name_or_message : "_"
      message ||= name_or_message
      let("g:ruby_debug.#{name}", message)
    end
  end
end
