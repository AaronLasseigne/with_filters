module WithFilters
  module Filter
    # @private
    class Select < Base
      def initialize(name, namespace, value, options = {})
        choices = options.delete(:choices) if options[:choices].is_a?(String)
        if choices
          Array.wrap(value).each do |v|
            matched = choices.sub!(/(<option[^>]*value\s*=\s*['"]?#{v}[^>]*)/, '\1 selected="selected"')
            unless matched
              choices.sub!(/>#{v}</, " selected=\"selected\">#{v}<")
            end 
          end
        end

        super

        @choices = choices if choices
      end
    end
  end
end
