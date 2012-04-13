module WithFilters
  module Filter
    # @private
    class Choice
      attr_reader :field_name, :label, :value, :attrs

      def initialize(field_name, label, value, options = {})
        @field_name = "#{field_name}[]"
        @label      = label
        @value      = value

        options[:id] ||= "#{field_name}_#{value}".gsub(']', '').gsub(/[^-a-zA-Z0-9:.]/, '_')

        @selected = !!options.delete(:selected)
        @attrs    = options
      end

      def selected?
        @selected
      end
    end
  end
end
