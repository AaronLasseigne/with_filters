module WithFilters
  module ValuePrep
    # @private
    class DefaultPrep
      # @param [Array, Hash, String] value The value to filter on.
      # @param [Hash] options
      # @option options [Symbol] :match Determines the way the filter is matched.
      #   Accepts `:exact`, `:contains`, `:begins_with` and `:ends_with`.
      # 
      # @since 0.1.0
      def initialize(value, options = {})
        @value   = value
        @options = options
      end

      # Returns the value so that it is ready to be filtered with.
      #
      # @return [Array, Hash, String]
      #
      # @since 0.1.0
      def value
        @prepared_value ||= if @value.is_a?(Hash)
          {start: prepare_start_value(@value[:start]), stop: prepare_stop_value(@value[:stop])}
        else
          temp = Array.wrap(@value).map do |value|
            add_match(prepare_value(value))
          end
          temp.length == 1 ? temp.first : temp
        end
      end

      private

      # Prepares a value for use in the filter.
      #
      # @param [String] value The value to filter on.
      #
      # @return [String]
      #
      # @since 0.1.0
      def prepare_value(value)
        value.respond_to?(:strip) ? value.strip : value
      end

      # Prepares the start value for a ranged filter.
      #
      # @param [String] value The value to filter on.
      #
      # @return [String]
      #
      # @since 0.1.0
      def prepare_start_value(value)
        prepare_value(value)
      end

      # Prepares the stop value for a ranged filter.
      #
      # @param [String] value The value to filter on.
      #
      # @return [String]
      #
      # @since 0.1.0
      def prepare_stop_value(value)
        prepare_value(value)
      end

      # Add string matchers based on the `:match` option passed to #initialize.
      #
      # @param [String] value The value to filter on.
      #
      # @return [String]
      #
      # @since 0.1.0
      def add_match(value)
        case @options[:match]
        when :contains
          "%#{value}%"
        when :begins_with
          "#{value}%"
        when :ends_with
          "%#{value}"
        else
          value
        end
      end
    end
  end
end
