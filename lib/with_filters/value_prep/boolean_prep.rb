module WithFilters
  module ValuePrep
    class BooleanPrep < DefaultPrep
      def prepare_value(value)
        (super == 'true')
      end
    end
  end
end
