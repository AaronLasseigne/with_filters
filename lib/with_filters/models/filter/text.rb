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
    end
  end
end
