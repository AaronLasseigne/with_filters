module WithFilters
  # @private
  module HashExtraction
    # Extracts the value from a hash and takes nesting into account.
    #
    # @param [Hash] hash The hash to search.
    # @param [String, Symbol] key The key or nested key to search for.
    #
    # @return [Object, nil]
    #
    # @example Key is a symbol.
    #   extract_hash_key({foo: 'bar'}, :foo) # => 'bar'
    #
    # @example Key is a string with nesting.
    #   extract_hash_key({foo: {bar: 'baz'}}, 'foo[:bar]') # => 'baz'
    #
    # @since 0.1.0
    def extract_hash_value(hash, key)
      key  = key.to_s
      hash = hash.stringify_keys
      
      if hash[key]
        hash[key]
      else
        first_key, remaining_content = key.to_s.match(/^([^\[]+)(.*)$/).captures

        eval "hash[first_key]#{remaining_content.gsub(/\[/, '["').gsub(/]/, '"]')} rescue nil"
      end
    end
  end
end
