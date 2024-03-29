module WithFilters
  module Filter
    # @private
    class Base
      attr_reader :to_partial_path, :label, :label_attrs, :field_name, :value, :attrs, :collection

      def initialize(name, namespace, value, options = {})
        @value = value

        @theme       = options.delete(:theme)
        @label       = options.delete(:label) || name.to_s.titleize
        @label_attrs = options.delete(:label_attrs) || {}
        @field_name  = options[:field_name] || "#{namespace}[#{name}]"
        @collection  = options[:collection] ? Collection.new(@field_name, options.delete(:collection) || [], {selected: value}) : nil
        @attrs       = options

        @to_partial_path = create_partial_path
      end

      private

      def create_partial_path
        partial_path = self.class.name.underscore

        if @theme
          themed_partial_path = partial_path.split(File::SEPARATOR).insert(1, @theme)
          if Dir.glob(File.join(Rails.root, 'app', 'views', *themed_partial_path).sub(/([^#{File::SEPARATOR}]+?)$/, '_\1.*')).any?
            partial_path = themed_partial_path.join(File::SEPARATOR)
          end
        end

        partial_path
      end
    end
  end
end
