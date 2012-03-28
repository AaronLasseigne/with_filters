module WithFilters
  # @private
  module ValuePrep
    # A mapping of Rails column types to value preparation class.
    #
    # since 0.1.0
    TYPE_MAP = {
      boolean:   BooleanPrep,
      date:      DatePrep,
      datetime:  DateTimePrep,
      timestamp: DateTimePrep
    }

    # A factory returning a class that prepares filter values based on a Rails
    # column type.
    #
    # @param [Symbol] column_type A Rails column type.
    # @param [String] value Value to be passed to the value preparation class.
    # @param [Hash] options Options to be passed to the value preparation class.
    #
    # @return [WithFilters::DefaultPrep, Inherited from WithFilters::DefaultPrep]
    #
    # since 0.1.0
    def self.prepare(column_type, value, options = {})
      (TYPE_MAP[column_type].try(:new, value, options) || DefaultPrep.new(value, options)).value
    end
  end
end
