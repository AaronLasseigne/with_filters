module WithFilters
  module Filter
    # @private
    class Select < Base
      def initialize(name, namespace, value, options = {})
        collection = options.delete(:collection) if options[:collection].is_a?(String)
        if collection
          Array.wrap(value).each do |v|
            matched = collection.sub!(/(<option[^>]*value\s*=\s*['"]?#{v}[^>]*)/, '\1 selected="selected"')
            unless matched
              collection.sub!(/>#{v}</, " selected=\"selected\">#{v}<")
            end 
          end
        end

        super

        @collection = collection if collection
      end
    end
  end
end
