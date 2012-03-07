module WithFilters
  module Filter
    TYPES = {
      :'datetime-local' => Text,
      text:     Text,
      email:    Text,
      url:      Text,
      tel:      Text,
      number:   Text,
      range:    Text,
      date:     Text,
      month:    Text,
      week:     Text,
      time:     Text,
      datetime: Text,
      search:   Text,
      color:    Text,
      hidden:   Text,
      radio:    Radio,
      select:   Select
    }

    RANGED_TYPES = {
      :'datetime-local' => TextRange,
      text:     TextRange,
      email:    TextRange,
      url:      TextRange,
      tel:      TextRange,
      number:   TextRange,
      range:    TextRange,
      date:     TextRange,
      month:    TextRange,
      week:     TextRange,
      time:     TextRange,
      datetime: TextRange,
      search:   TextRange,
      color:    TextRange,
      select:   SelectRange
    }

    def self.create(name, namespace, value, options = {})
      as = options.delete(:as) || (options.has_key?(:choices) ? :select : :text)

      options[:type] = as.to_s

      TYPES[as].new(name, namespace, value, options)
    end

    def self.create_range(name, namespace, value, options = {})
      as = options.delete(:as) || (options.has_key?(:choices) ? :select : :text)

      options[:type] = as.to_s

      RANGED_TYPES[as].new(name, namespace, value, options)
    end
  end
end
