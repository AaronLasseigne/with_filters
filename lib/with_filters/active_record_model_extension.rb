module WithFilters
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      # switch from scope to class method because of a bug in Rails 3.2.1 where
      # joins_values aren't available in scopes
      def self.with_filters(params = nil, options = {})
        relation = self.scoped
        param_namespace = options[:param_namespace] || relation.table_name.to_sym
        scoped_params = params.try(:[], param_namespace)

        if scoped_params and scoped_params[:filter]
          scoped_params[:filter].each do |field, value|
            # skip blank entries
            value = value.reject{|v| v.blank?} if value.is_a?(Array)
            if (value.is_a?(String) and value.blank?) or
               (value.is_a?(Array) and value.empty?) or
               (value.is_a?(Hash) and not (value[:start].present? and value[:stop].present?))
              next
            end

            quoted_field = relation.connection.quote_column_name(field)

            db_column = find_column(relation, field)

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
            quoted_field = relation.column_names.include?(field.to_s) ? "#{self.table_name}.#{quoted_field}" : quoted_field
            relation = case value.class.name.to_sym
              when :Array
                relation.where(["#{quoted_field} IN(?)", value])
              when :Hash
                relation.where(["#{quoted_field} BETWEEN :start AND :stop", value])
              when :String, :FalseClass, :TrueClass, :Date, :Time
                value.strip! if value.respond_to?(:strip!)
                value = value.to_s(:db) + '%' if has_decimal_seconds?(value, db_column)
                relation.where(["#{quoted_field} LIKE ?", value])
              else
                relation
            end
          end
        end

        relation
      end
    end

    module ClassMethods
      def find_column(relation, field)
        field = field.to_s
        relation.columns.detect{|column| column.name == field} ||
          (   
           (relation.respond_to?(:joins_values) ? relation.joins_values : []) +
           (relation.respond_to?(:includes_values) ? relation.includes_values : []) 
          ).uniq.map{|join|
            # convert string joins to table names
            if join.is_a?(String)
              join.scan(/\G(?:(?:,|\bjoin\s)\s*(\w+))/i)
            else
              join
            end 
          }.flatten.map{|table_name|
            ActiveRecord::Base::connection.columns(table_name.to_s.tableize)
          }.flatten.detect{|column|
            column.name == field
          }   
      end

      def has_decimal_seconds?(value, column)
        !!(ActiveRecord::Base.connection.type_cast(value, column).to_s =~ /\.\d+$/)
      end
    end
  end
end
