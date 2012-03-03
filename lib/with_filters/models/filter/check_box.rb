module WithFilters
  module Filter
    class CheckBox < Base
      def initialize(name, namespace, value, options = {})
        super

        @to_partial_path += 'es' unless self.choices.nil?
      end

      def selected?
        if self.choices.nil?
          (value.to_s == 'true')
        else
          value.present?
        end
      end
    end
  end
end
