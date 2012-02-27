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
        prepare_it(value, '000000', 0.0)
      end

      def prepare_stop_value(value)
        prepare_it(value, '235959', 0.999999)
      end

      private

      def prepare_it(value, time, sec_fraction)
        date_info = Date._parse(value)

        to_s_with_sec_fraction(date_info.has_key?(:hour) ? value : ("%<year>d%02<mon>d%02<mday>d#{time}" % date_info), date_info[:sec_fraction] || sec_fraction)
      end

      def to_s_with_sec_fraction(value, sec_decimal)
        Time.zone.parse(value).to_s(:db) + ('%.6f' % sec_decimal)[1..-1]
      end
    end
  end
end
