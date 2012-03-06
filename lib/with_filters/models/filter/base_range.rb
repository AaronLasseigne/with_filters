module WithFilters
  module Filter
    class BaseStart < Base
      def initialize(name, namespace, value, options = {})
        super

        @field_name += '[start]'
      end
    end

    class BaseStop < Base
      def initialize(name, namespace, value, options = {})
        super

        @field_name += '[stop]'
      end
    end

    class BaseRange < Base
      attr_reader :start, :stop

      def initialize(name, namespace, value, options = {})
        start_attrs = options.delete(:start) || {}
        stop_attrs  = options.delete(:stop)  || {}

        super

        start_attrs.reverse_merge!(@attrs)
        start_attrs.reverse_merge!(label: self.label, label_attrs: self.label_attrs)
        stop_attrs.reverse_merge!(@attrs)
        stop_attrs.reverse_merge!(label: self.label, label_attrs: self.label_attrs)

        @start = BaseStart.new(name, namespace, value[:start], start_attrs)
        @stop  = BaseStop.new(name, namespace, value[:stop], stop_attrs)
      end
    end
  end
end
