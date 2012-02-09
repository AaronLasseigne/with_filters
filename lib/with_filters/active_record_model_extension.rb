module WithFilters
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      self.scope :with_filters, ->(params = nil) {
        scope = self.scoped
        scoped_params = params.try(:[], scope.table_name.to_sym)

        if scoped_params and scoped_params[:filter]
          scoped_params[:filter].each do |name, value|
            # skip blank entries
            value = value.reject{|v| v.blank?} if value.is_a?(Array)
            if (value.is_a?(String) and value.blank?) or
               (value.is_a?(Array) and value.empty?) or
               (value.is_a?(Hash) and not (value[:start].present? and value[:stop].present?))
              next
            end

            quoted_name = scope.connection.quote_column_name(name)

            db_column = find_column(scope, name)

            # prep values
            value = case db_column.type
              when :boolean
                (value == 'true')
              when :date
                value.is_a?(Hash) ? {start: value[:start].to_date, stop: value[:stop].to_date} : value.to_date
              when :datetime, :timestamp
                if value.is_a?(Hash)
                  start_time = Time.zone.parse(value[:start])
                  stop_time  = Time.zone.parse(value[:stop])

                  stop_time = stop_time.advance(seconds: 1) if has_decimal_seconds?(start_time, db_column)

                  {start: start_time.to_s(:db), stop: stop_time.to_s(:db)}
                else
                  Time.zone.parse(value)
                end
              else
                value
            end

            # attach filter
            scope = case value.class.name.to_sym
              when :Array
                scope.where(["#{quoted_name} IN(?)", value])
              when :Hash
                scope.where(["#{quoted_name} BETWEEN :start AND :stop", value])
              when :String, :FalseClass, :TrueClass, :Date, :Time
                value.strip! if value.respond_to?(:strip!)
                value = value.to_s(:db) + '%' if has_decimal_seconds?(value, db_column)
                scope.where(["#{quoted_name} LIKE ?", value])
              else
                scope
            end
          end
        end

        scope
      }
    end

    module ClassMethods
      def find_column(scope, field)
        field = field.to_s
        scope.columns.detect{|column| column.name == field} ||
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
      end

      def has_decimal_seconds?(value, column)
        !!ActiveRecord::Base.connection.type_cast(value, column).index(/\.\d+$/)
      end
    end
  end
end
