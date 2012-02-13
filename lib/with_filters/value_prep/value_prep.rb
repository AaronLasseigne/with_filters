module WithFilters
  module ValuePrep
    TYPE_MAP = {
      boolean:   BooleanPrep,
      date:      DatePrep,
      datetime:  DateTimePrep,
      timestamp: DateTimePrep
    }

    def self.prepare(column, value, options = {})
      (TYPE_MAP[column.type].try(:new, column, value, options) || DefaultPrep.new(column, value, options)).value
    end
  end
end
