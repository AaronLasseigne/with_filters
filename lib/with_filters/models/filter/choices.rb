module WithFilters
  module Filter
    class Choices < Array
      def initialize(choices)
        choices = choices.to_a if choices.is_a?(Range)

        choices.map do |element|
          text, value, choice_options = if element.is_a?(Array)
                                          html_attrs = element.detect {|e| Hash === e} || {}
                                          element = element.reject {|e| Hash === e}  
                                          [element.first.to_s, element.last, html_attrs]
                                        elsif !element.is_a?(String) && element.respond_to?(:first) && element.respond_to?(:last)
                                          [element.first.to_s, element.last, {}] 
                                        else
                                          [element.to_s, element, {}] 
                                        end

          self.push(Choice.new(text, value, choice_options))
        end
      end
    end
  end
end
