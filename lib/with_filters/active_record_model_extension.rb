module WithFilters
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      self.scope :with_filters, ->(params = nil) {
        scoped_params = params.try(:[], self.table_name.to_sym)
        scope = self.scoped

        if scoped_params and scoped_params[:filter]
          scoped_params[:filter].each do |name, value|
            quoted_name = scope.connection.quote_column_name(name)

            case value.class.to_s
              when 'Array'
                scope = scope.where(["#{quoted_name} IN(?)", value])
              when 'Hash'
                scope = scope.where(["#{quoted_name} BETWEEN :start AND :stop", value])
              else
                scope = scope.where(["#{quoted_name} LIKE ?", value])
            end
          end
        end

        scope
      }
    end
  end
end
