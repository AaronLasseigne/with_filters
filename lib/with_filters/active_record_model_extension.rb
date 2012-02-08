module WithFilters
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      self.scope :with_filters, ->(params = nil) {
        scope = self.scoped
        scoped_params = params.try(:[], scope.table_name.to_sym)

        if scoped_params and scoped_params[:filter]
          scoped_params[:filter].each do |name, value|
            value = value.reject{|v| v.blank?} if value.is_a?(Array)
            if (value.is_a?(String) and value.blank?) or
               (value.is_a?(Array) and value.empty?) or
               (value.is_a?(Hash) and not (value[:start].present? and value[:stop].present?))
              next
            end

            quoted_name = scope.connection.quote_column_name(name)

            # prep values
            case find_column_type(scope, name)
              when :boolean
                value = (value == 'true')
            end

            # attach filter
            case value.class.name.to_sym
              when :Array
                scope = scope.where(["#{quoted_name} IN(?)", value])
              when :Hash
                scope = scope.where(["#{quoted_name} BETWEEN :start AND :stop", value])
              when :String, :FalseClass, :TrueClass
                scope = scope.where(["#{quoted_name} LIKE ?", value.respond_to?(:strip) ? value.strip : value])
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
