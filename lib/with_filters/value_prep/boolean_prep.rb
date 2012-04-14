module WithFilters
  module ValuePrep
    # @private
    class BooleanPrep < DefaultPrep
      def prepare_value(value)
        (super == 'on')
      end
    end
  end
end
