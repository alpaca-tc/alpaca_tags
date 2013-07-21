module AlpacaTags::TagsManager::Parser
  class Vim < Base
    def to_h
      return @to_h if @to_h

      vim_hash = super
      vim_hash[:word] = vim_hash[:tagname]
      vim_hash[:attr] = "#{vim_hash[:tagname]} #{vim_hash[:tagfile].truncate(10, '...')}"
      vim_hash[:kind] = 'jump_list'
      vim_hash[:action_path] = vim_hash[:tagaddress]
      vim_hash[:action_tagname] = vim_hash[:tagname]
      vim_hash[:source__extensions] = vim_hash[:extensions]
      @to_h = vim_hash
    end
  end
end
