module WithFilters
  module ValuePrep
    class DatePrep < DefaultPrep
      def prepare_value(value)
        super.to_date
      end
    end
  end
end
