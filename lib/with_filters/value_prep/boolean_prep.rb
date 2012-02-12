module WithFilters
  module ValuePrep
    class BooleanPrep < DefaultPrep
      def prepared_value
        (super == 'true')
      end
    end
  end
end
