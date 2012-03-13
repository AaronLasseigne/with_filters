module WithFilters
  module Filter
    class Text < Base
      def initialize(name, namespace, value, options = {})
        super

        if @attrs[:type] != :text
          new_partial = @to_partial_path.split(File::SEPARATOR)
          new_partial[-1] = "_#{new_partial[-1]}_as_#{@attrs[:type]}.*"

          @to_partial_path += "_as_#{@attrs[:type]}" if Dir.glob(File.join(Rails.root, 'app', 'views', *new_partial)).any?
        end
      end

      def create_partial_path
        partial_path = nil
        if @theme and @attrs[:type] != :text
          themed_partial_path = self.class.name.underscore.split(File::SEPARATOR).insert(1, @theme)
          themed_partial_path[themed_partial_path.length - 1] += "_as_#{@attrs[:type]}"
          if Dir.glob(File.join(Rails.root, 'app', 'views', *themed_partial_path).sub(/([^#{File::SEPARATOR}]+?)$/, '_\1.*')).any?
            partial_path = themed_partial_path.join(File::SEPARATOR)
          end
        end

        partial_path || super
      end
    end
  end
end
