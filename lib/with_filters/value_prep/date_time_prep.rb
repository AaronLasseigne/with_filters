module WithFilters
  module ValuePrep
    class DateTimePrep < DefaultPrep
      def prepared_value
        @value = super

        # convert dates to datetimes
        if @value.is_a?(String)
          date_info = Date._parse(@value)
          unless date_info.has_key?(:hour)
            @value = "#{@value.to_date}%"
          end
        elsif @value.is_a?(Hash)
          start_date_info = Date._parse(@value[:start])
          stop_date_info  = Date._parse(@value[:stop])
          unless start_date_info.has_key?(:hour) and stop_date_info.has_key?(:hour)
            start_date = '%<year>d%02<mon>d%02<mday>d' % start_date_info
            stop_date  = '%<year>d%02<mon>d%02<mday>d' % stop_date_info
            @value = {start: "#{start_date}000000", stop: "#{stop_date}235959"}
          end
        end

        if @value.is_a?(Hash)
          start_time = Time.zone.parse(@value[:start])
          stop_time  = Time.zone.parse(@value[:stop])

          stop_time = stop_time.advance(seconds: 1) if has_decimal_seconds?(start_time)

          @value = {start: start_time.to_s(:db), stop: stop_time.to_s(:db)}
        elsif @value !~ /%$/
          parsed_value = Time.zone.parse(@value)
          @value = has_decimal_seconds?(parsed_value) ? parsed_value.to_s(:db) + '%' : parsed_value.to_s(:db)
        end

        @value
      end

      def has_decimal_seconds?(value)
        !!(ActiveRecord::Base.connection.type_cast(value, @column).to_s =~ /\.\d+$/)
      end
      private :has_decimal_seconds?
    end
  end
end
