module WithFilters
  module HashExtraction
    def extract_hash_value(hash, key)
      return hash[key] if key.is_a?(Symbol)

      first_key, remaining_content = key.to_s.match(/^([^\[]+)(.*)$/).captures

      if remaining_content == ''
        hash[first_key]
      else
        eval "hash[first_key.to_sym]#{remaining_content} rescue nil"
      end
    end
  end
end
