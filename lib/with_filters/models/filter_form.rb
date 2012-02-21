module WithFilters
  class FilterForm
    attr_reader :attrs, :to_partial_path, :filters

    def initialize(records, options = {})
      @records = records

      @attrs           = options.reverse_merge(novalidate: 'novalidate', method: 'get')
      @to_partial_path = self.class.name.underscore
      @filters         = []
    end

    def input(name, options = {})
      @filters.push(WithFilters::Filter.create(name, @records.with_filters_data[:param_namespace], options))
    end
  end
end
