module WithFilters
  module ValuePrep
    class DateTimePrep < DefaultPrep
      def prepare_value(value)
        value = super
        date_info = Date._parse(value)

        if date_info.has_key?(:sec_fraction)
          to_parsed_s(value, {}, date_info[:sec_fraction].to_f)
        else
          {start: prepare_start_value(value), stop: prepare_stop_value(value)}
        end
      end

      def prepare_start_value(value)
        date_info = Date._parse(value)

        if date_info.has_key?(:sec_fraction)
          to_parsed_s(value, {}, date_info[:sec_fraction])
        else
          to_parsed_s(value)
        end
      end

      def prepare_stop_value(value)
        date_info = Date._parse(value)

        if date_info.has_key?(:sec_fraction)
          to_parsed_s(value, {}, date_info[:sec_fraction])
        elsif date_info.has_key?(:sec)
          to_parsed_s(value, seconds: 1)
        elsif date_info.has_key?(:min)
          to_parsed_s(value, minutes: 1)
        elsif date_info.has_key?(:hour)
          to_parsed_s(value, hours: 1)
        elsif date_info.has_key?(:mday)
          to_parsed_s(value, days: 1)
        end
      end

      private

      def to_parsed_s(value, advance_options = {}, sec_decimal = nil)
        parsed_s = Time.zone.parse(value).advance(advance_options).to_s(:db)
        parsed_s += ('%.6f' % sec_decimal)[1..-1] if sec_decimal
        parsed_s
      end
    end
  end
end
