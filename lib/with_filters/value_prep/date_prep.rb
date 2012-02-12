module WithFilters
  module ValuePrep
    class DatePrep < DefaultPrep
      def prepared_value
        @value = super

        if @value.is_a?(Hash)
          {start: @value[:start].to_date, stop: @value[:stop].to_date}
        elsif @value.is_a?(Array)
          @value.map(&:to_date)
        else
          @value.to_date
        end
      end
    end
  end
end
