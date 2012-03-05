module WithFilters
  module ValuePrep
    class DateTimePrep < DefaultPrep
      def prepare_value(value)
        value = super
        date_info = Date._parse(value)

        if date_info.has_key?(:sec_fraction)
          to_s_with_sec_fraction(value, date_info[:sec_fraction].to_f)
        else
          {start: prepare_start_value(value), stop: prepare_stop_value(value)}
        end
      end

      def prepare_start_value(value)
        date_info = Date._parse(value)

        if date_info.has_key?(:sec_fraction)
          to_s_with_sec_fraction(value, date_info[:sec_fraction])
        else
          Time.zone.parse(value).to_s(:db)
        end
      end

      def prepare_stop_value(value)
        date_info = Date._parse(value)

        if date_info.has_key?(:sec_fraction)
          to_s_with_sec_fraction(value, date_info[:sec_fraction])
        elsif date_info.has_key?(:sec)
          Time.zone.parse(value).advance(seconds: 1).to_s(:db)
        elsif date_info.has_key?(:mday)
          Time.zone.parse(value).advance(days: 1).to_s(:db)
        end
      end

      private

      def to_s_with_sec_fraction(value, sec_decimal)
        Time.zone.parse(value).to_s(:db) + ('%.6f' % sec_decimal)[1..-1]
      end
    end
  end
end
