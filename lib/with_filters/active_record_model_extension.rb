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

            db_column = find_column(relation, field)

            value = WithFilters::ValuePrep.prepare(db_column, value, options)

            quoted_field = relation.connection.quote_column_name(field)
            quoted_field = relation.column_names.include?(field.to_s) ? "#{self.table_name}.#{quoted_field}" : quoted_field

            # attach filter
            relation = case value.class.name.to_sym
              when :Array
                relation.where(["#{quoted_field} IN(?)", value])
              when :Hash
                relation.where(["#{quoted_field} BETWEEN :start AND :stop", value])
              when :String, :FalseClass, :TrueClass, :Date, :Time
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
    end
  end
end
