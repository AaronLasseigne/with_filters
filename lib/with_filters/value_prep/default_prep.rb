module WithFilters
  module ValuePrep
    class DefaultPrep
      def initialize(column, value, options = {})
        @column  = column
        @value   = value
        @options = options
      end

      def value
        @prepared_value ||= if @value.is_a?(Hash)
          {start: self.prepare_start_value(@value[:start]), stop: self.prepare_stop_value(@value[:stop])}
        else
          temp = Array.wrap(@value).map do |value|
            self.prepare_value(value)
          end
          temp.length == 1 ? temp.first : temp
        end
      end

      def prepare_value(value)
        value.respond_to?(:strip) ? value.strip : value
      end

      def prepare_start_value(value)
        self.prepare_value(value)
      end

      def prepare_stop_value(value)
        self.prepare_value(value)
      end
    end
  end
end
