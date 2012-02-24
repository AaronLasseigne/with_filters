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
      radio:    Radio
    }

    def self.create(name, namespace, value, options = {})
      as = options.delete(:as) || (options.has_key?(:choices) ? :radio : :text)

      options[:type] = as.to_s

      TYPES[as].new(name, namespace, value, options)
    end
  end
end
