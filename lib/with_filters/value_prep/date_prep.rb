module WithFilters
  module ValuePrep
    # @private
    class DatePrep < DefaultPrep
      def prepare_value(value)
        super.to_date
      end
    end
  end
end
