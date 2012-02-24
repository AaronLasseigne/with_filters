module WithFilters
  module Filter
    class Choice
      attr_reader :label, :value, :attrs

      def initialize(label, value, options = {})
        @label = label
        @value = value

        @selected = !!options.delete(:selected)
        @attrs    = options
      end

      def selected?
        @selected
      end
    end
  end
end
