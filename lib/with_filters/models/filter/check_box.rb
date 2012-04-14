module WithFilters
  module Filter
    # @private
    class CheckBox < Base
      def initialize(name, namespace, value, options = {})
        super

        @to_partial_path << 'es' unless self.collection.nil?
      end

      def selected?
        if self.collection.nil?
          value.to_s == 'on'
        else
          value.present?
        end
      end
    end
  end
end
