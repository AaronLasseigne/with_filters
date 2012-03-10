module WithFilters
  module ValuePrep
    TYPE_MAP = {
      boolean:   BooleanPrep,
      date:      DatePrep,
      datetime:  DateTimePrep,
      timestamp: DateTimePrep
    }

    def self.prepare(column_type, value, options = {})
      (TYPE_MAP[column_type].try(:new, value, options) || DefaultPrep.new(value, options)).value
    end
  end
end
