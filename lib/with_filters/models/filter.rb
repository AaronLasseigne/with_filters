module WithFilters
  module Filter
    def self.create(name, namespace, value, options = {})
      WithFilters::Filter::Base.new(name, namespace, value, options)
    end
  end
end
