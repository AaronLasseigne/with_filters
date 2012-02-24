module WithFilters
  module Filter
    class Base
      attr_reader :to_partial_path, :label, :label_attrs, :field_name, :value, :attrs

      def initialize(name, namespace, value, options = {})
        @value = value

        @label       = options.delete(:label) || name.to_s.titleize
        @label_attrs = options.delete(:label_attrs) || {}
        @attrs       = options

        @field_name      = "#{namespace}[#{name}]"
        @to_partial_path = self.class.name.underscore
      end
    end
  end
end
