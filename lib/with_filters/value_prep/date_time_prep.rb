module WithFilters
  module ValuePrep
    class DateTimePrep < DefaultPrep
      def prepare_value(value)
        value = super
        date_info = Date._parse(value)

        if date_info.has_key?(:hour)
          parsed_value = Time.zone.parse(value)
          has_decimal_seconds?(parsed_value) ? parsed_value.to_s(:db) + '%' : parsed_value.to_s(:db)
        else
          "#{value.to_date}%"
        end
      end

      def prepare_start_value(value)
        date_info = Date._parse(value)

        Time.zone.parse(
          date_info.has_key?(:hour) ? value : ('%<year>d%02<mon>d%02<mday>d000000' % date_info)
        ).to_s(:db)
      end

      def prepare_stop_value(value)
        date_info = Date._parse(value)

        if date_info.has_key?(:hour)
          prepared_value = Time.zone.parse(value)
          prepared_value = prepared_value.advance(seconds: 1) if has_decimal_seconds?(prepared_value)
          prepared_value.to_s(:db)
        else
          Time.zone.parse('%<year>d%02<mon>d%02<mday>d235959' % date_info).to_s(:db)
        end
      end

      def has_decimal_seconds?(value)
        !!(ActiveRecord::Base.connection.type_cast(value, @column).to_s =~ /\.\d+$/)
      end
      private :has_decimal_seconds?
    end
  end
end
