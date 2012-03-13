module WithFilters
  class FilterForm
    attr_reader :attrs, :to_partial_path, :filters, :param_namespace

    def initialize(records, values = {}, options = {})
      @records = records
      @values  = values

      @theme           = options.delete(:theme)
      @attrs           = options.reverse_merge(novalidate: 'novalidate', method: 'get')
      @to_partial_path = self.class.name.underscore
      @filters         = []
      @param_namespace = @records.with_filters_data[:param_namespace]
    end

    def input(name, options = {})
      options[:as] = find_as(name, options.has_key?(:choices)) unless options[:as]
      options.merge!(theme: @theme)

      @filters.push(WithFilters::Filter.create(name, self.param_namespace, @values[name], options))
    end

    def input_range(name, options = {})
      options[:as] = find_as(name, options.has_key?(:choices)) unless options[:as]
      options.merge!(theme: @theme)

      @filters.push(WithFilters::Filter.create_range(name, self.param_namespace, @values[name] || {}, options))
    end

    private

    def find_as(name, has_choices)
      return :select if has_choices

      case @records.with_filters_data[:column_types][name]
      when :integer, :float, :decimal then :number
      when :date then :date
      when :time then :time
      when :datetime, :timestamp then :datetime
      when :boolean then :checkbox
      when :string
        case name
        when /email/ then :email
        when /url/ then :url
        when /phone/ then :tel
        else :text
        end
      else :text
      end
    end
  end
end
