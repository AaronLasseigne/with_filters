module WithFilters
  class FilterForm
    attr_reader :attrs, :to_partial_path, :filters, :param_namespace

    def initialize(records, values = {}, options = {})
      @records = records
      @values  = values

      @attrs           = options.reverse_merge(novalidate: 'novalidate', method: 'get')
      @to_partial_path = self.class.name.underscore
      @filters         = []
      @param_namespace = @records.with_filters_data[:param_namespace]
    end

    def input(name, options = {})
      @filters.push(WithFilters::Filter.create(name, self.param_namespace, @values[name], options))
    end
  end
end
