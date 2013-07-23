module AlpacaTags
  class Configuration
    def initialize
      add_setting :default_cache_path, default: '/tmp'
      add_setting :default_cache, default: ::AlpacaTags::Cache::Ruby
      add_setting :enable_caching, default: true
    end

    def self.add_setting(name, opts={})
      attr_accessor name
    end

    def add_setting(name, opts={})
      default = opts.delete(:default)
      (class << self; self; end).class_eval do
        add_setting(name, opts)
      end

      instance_variable_set("@#{name}", default) if default
    end
  end
end
