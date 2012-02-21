module WithFilters
  module Filter
    def self.create(name, namespace, options = {})
      WithFilters::Filter::Base.new(name, namespace, options)
    end
  end
end
