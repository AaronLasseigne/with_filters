module WithFilters
  module ValuePrep
    class DefaultPrep
      def initialize(column, value, options = {})
        @column  = column
        @value   = value
        @options = options
      end

      def value
        @prepared_value ||= prepared_value
      end

      def prepared_value
        if @value.is_a?(Array)
          @value.map do |v|
            v.strip if v.respond_to?(:strip)
          end
        elsif @value.is_a?(Hash)
          start_value = @value[:start]
          stop_value  = @value[:stop]
          @value = {
            start: start_value.respond_to?(:strip) ? start_value.strip : start_value,
            stop:  stop_value.respond_to?(:strip) ? stop_value.strip : stop_value
          }
        else
          @value.respond_to?(:strip) ? @value.strip : @value
        end
      end
      private :prepared_value
    end
  end
end
