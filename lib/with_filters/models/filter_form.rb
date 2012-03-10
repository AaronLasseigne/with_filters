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
      options[:as] = find_as(name, options.has_key?(:choices)) unless options[:as]

      @filters.push(WithFilters::Filter.create(name, self.param_namespace, @values[name], options))
    end

    def input_range(name, options = {})
      options[:as] = find_as(name, options.has_key?(:choices)) unless options[:as]

      @filters.push(WithFilters::Filter.create_range(name, self.param_namespace, @values[name] || {}, options))
    end

    private

    def find_column_type(name)
      name = name.to_s
      column = @records.columns.detect{|column| column.name == name} ||
      (
        (@records.respond_to?(:joins_values) ? @records.joins_values : []) +
        (@records.respond_to?(:includes_values) ? @records.includes_values : [])
      ).uniq.map{|join|
        # convert string joins to table names
        if join.is_a?(String)
          join.scan(/\G(?:(?:,|\bjoin\s)\s*(\w+))/i)
        else
          join
        end
      }.flatten.map{|table_name|
        ActiveRecord::Base::connection_pool.columns[table_name.to_s.tableize]
      }.flatten.detect{|column|
        column.name == name
      }
      column.try(:type)
    end

    def find_as(name, has_choices)
      return :select if has_choices

      name = name.to_s

      case find_column_type(name)
      when :integer, :float, :decimal then :number
      when :date then :date
      when :time then :time
      when :datetime, :timestamp then :datetime
      when :boolean then :checkbox
      when :text
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
