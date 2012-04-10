module WithFilters
  module ActionViewExtension
    include WithFilters::HashExtraction

    # Create a filter form.
    #
    # @param records [ActiveRecord::Relation, Array] The data being filtered.
    # @param options [Hash]
    # @option options [String] :theme The theme to use when rendering the form.
    # @option options [Varied] remaining ("{'novalidate: 'novalidate', method: 'get'}")
    #   All other options are passed as options to the `form_tag` helper.
    #
    # @example
    #   <%= filter_form_for(@data, theme: 'foo', class: 'bar') do |f|
    #     f.input(:full_name)
    #     f.input(:email)
    #   end %>
    #
    # @since 0.1.0
    def filter_form_for(records, options = {})
      filter_form = WithFilters::FilterForm.new(records, self.extract_hash_value(params, records.with_filters_data[:param_namespace]) || {}, options)
      yield(filter_form)

      render(partial: filter_form.to_partial_path, locals: {filter_form: filter_form})
    end

    # Create hidden inputs.
    #
    # @param [Array<Filter>] hidden_filters
    #
    # @since 0.1.0
    def with_filters_hidden(hidden_filters)
      hidden_filters.map{|hidden_filter|
        hidden_field_tag(hidden_filter.field_name, hidden_filter.value, hidden_filter.attrs)
      }.join("\n")
    end

    # Create an input based on the type of `filter` provided.
    #
    # @param [Filter] filter
    #
    # @since 0.1.0
    def with_filters_input(filter)
      render(partial: filter.to_partial_path, locals: {filter: filter})
    end

    # Create an text like `input` tag based on the `filter`.
    #
    # @param [Filter] filter
    #
    # @since 0.1.0
    def with_filters_text_field_tag(filter)
      text_field_tag(filter.field_name, filter.value, filter.attrs)
    end

    # Create a `label` tag based on the `filter`.
    #
    # @param [Filter] filter
    #
    # @since 0.1.0
    def with_filters_label_tag(filter)
      label_tag(filter.field_name, filter.label, filter.label_attrs)
    end

    # Create a `label` tag for individual fields or a `div` tag in its place in
    # the case of fields where the `label` tags are used for individual items.
    #
    # @param [Filter] filter
    #
    # @since 0.1.0
    def with_filters_label(filter)
      if [WithFilters::Filter::Radio, WithFilters::Filter::CheckBox].include?(filter.class) and filter.collection.any?
        content_tag(:div, filter.label, filter.label_attrs)
      else
        with_filters_label_tag(filter)
      end
    end

    # Create a `select` tag based on the `filter`.
    #
    # @param [Filter] filter
    #
    # @since 0.1.0
    def with_filters_select_tag(filter)
      collection = filter.collection
      unless filter.collection.is_a?(String)
        collection = filter.collection.map do |choice|
          html_attributes = choice.attrs.length > 0 ? ' ' + choice.attrs.map {|k, v| %(#{k.to_s}="#{v}")}.join(' ') : ''
          selected_attribute = choice.selected? ? ' selected="selected"' : ''

          %(<option value="#{ERB::Util.html_escape(choice.value)}"#{selected_attribute}#{html_attributes}>#{ERB::Util.html_escape(choice.label)}</option>)
        end.join("\n")
      end

      select_tag(filter.field_name, collection.html_safe, filter.attrs)
    end
  end
end
