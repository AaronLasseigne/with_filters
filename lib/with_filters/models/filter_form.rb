module WithFilters
  class FilterForm
    attr_reader :attrs, :partial_path, :filters

    def initialize(records)
      @records = records

      @attrs        = {novalidate: 'novalidate'}
      @partial_path = self.class.name.underscore
      @filters      = []
    end

    def input(name)
      @filters.push(WithFilters::Filter.new(name, @records.with_filters_data[:param_namespace]))
    end
  end
end
