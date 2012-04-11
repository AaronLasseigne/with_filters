module WithFilters
  class FilterForm
    attr_reader :attrs, :to_partial_path, :filters, :param_namespace, :hidden_filters, :actions

    # @see ActionViewExtension#filter_form_for
    #
    # @since 0.1.0
    def initialize(records, values = {}, options = {})
      @records = records
      @values  = values

      @theme = options.delete(:theme)
      @attrs = options.reverse_merge(novalidate: 'novalidate', method: 'get')

      @to_partial_path = self.class.name.underscore
      @param_namespace = @records.with_filters_data[:param_namespace]
      @hidden_filters  = []
      @filters         = []
      @actions         = []
    end

    # @see input
    #
    # @since 0.1.0
    def hidden(name, options = {})
      options.merge!(as: :hidden)

      input(name, options)
    end

    # @param [Symbol] name
    # @param [Hash] options
    #
    # @since 0.1.0
    def input(name, options = {})
      options[:as] = find_as(name, options[:collection]) unless options[:as]
      options.merge!(theme: @theme)
      as = options[:as]

      filter = WithFilters::Filter.create(name, self.param_namespace, @values[name], options)

      (as == :hidden ? @hidden_filters : @filters).push(filter)
    end

    # @param [Symbol] name
    # @param [Hash] options
    #
    # @since 0.1.0
    def input_range(name, options = {})
      options[:as] = find_as(name, options[:collection]) unless options[:as]
      options.merge!(theme: @theme)

      @filters.push(WithFilters::Filter.create_range(name, self.param_namespace, @values[name] || {}, options))
    end

    # @param [Symbol] type
    # @param [Hash] options
    #
    # @since 0.1.0
    def action(type, options = {})
      @actions.push(WithFilters::Action.new(type, options))
    end

    private

    # Converts a database column type to an input type.
    #
    # @param [Symbol] name
    # @param [Boolean] has_collection Indicates whether or not there is a collection
    #   associated with the input data.
    #
    # @since 0.1.0
    def find_as(name, has_collection)
      return :select if has_collection

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
