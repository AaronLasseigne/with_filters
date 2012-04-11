module WithFilters
  class Action
    attr_accessor :type, :attrs

    def initialize(type, options = {})
      @type = type

      options[:type]  = @type
      options[:value] = options.delete(:label) if options[:label]

      @attrs = options
    end
  end
end
