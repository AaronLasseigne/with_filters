module WithFilters
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      self.scope :with_filters, ->(params = nil) {
        scope = self.scoped
        scoped_params = params.try(:[], scope.table_name.to_sym)

        if scoped_params and scoped_params[:filter]
          scoped_params[:filter].each do |name, value|
            quoted_name = scope.connection.quote_column_name(name)

            # prep values
            case find_column_type(scope, name)
              when :boolean
                value = (value == 'true')
            end

            # attach filter
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

    module ClassMethods
      def find_column_type(scope, field)
        field = field.to_s
        column = scope.columns.detect{|column| column.name == field} ||
          (   
           (scope.respond_to?(:joins_values) ? scope.joins_values : []) +
           (scope.respond_to?(:includes_values) ? scope.includes_values : []) 
          ).uniq.map{|join|
            # convert string joins to table names
            if join.is_a?(String)
              join.scan(/\G(?:(?:,|\bjoin\s)\s*(\w+))/i)
            else
              join
            end 
          }.flatten.map{|table_name|
            ActiveRecord::Base::connection_pool.columns[table_name.to_s.tableize]
          }.flatten.detect{|column|
            column.name == field
          }   
          column.try(:type)
      end
      private :find_column_type
    end
  end
end
