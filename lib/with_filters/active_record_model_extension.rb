module WithFilters
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    # @private
    module AddData
      # @return [Hash<:column_types, :param_namespace>] Properties relating to the current filters.
      #
      # @since 0.1.0
      attr_accessor :with_filters_data
    end

    # Attaches conditions to a scope.
    #
    # @scope class
    # @overload with_filters(params = nil, options = {})
    #   @param [Hash] params A hash of values to filter on.
    #   @param [Hash] options
    #   @option options [Symbol] :param_namespace ('primary table name') The namespace
    #     of the filters inside `params`.
    #   @option options [Hash, Proc] :fields When a hash is passed this is a mapping
    #     of custom fields to field options. When a proc is passed it is sent `value`
    #     and `scope` and is expected to return the scope.
    #   @option options [String] :fields[:column] The database column to map the field to.
    #   @option options [Symbol] :fields[:match] Determines the way the filter is matched.
    #     Accepts `:exact`, `:contains`, `:begins_with` and `:ends_with`.
    #
    #   @example Basic
    #     with_filters(params)
    #
    #   @example With a custom matching and field name.
    #     with_filters(params, {fields: {
    #       given_name: {column: 'first_name', match: :contains}
    #     }})
    #
    #   @example With a custom field using a proc.
    #     with_filters(params, {fields: {
    #       full_name: ->(value, scope) {
    #         first_word, second_word = value.strip.split(/\s+/)
    #
    #         if second_word
    #           scope.where(['first_name LIKE ? OR last_name LIKE ?', first_word, first_word])
    #         else
    #           scope.where(['first_name LIKE ? AND last_name LIKE ?', first_word, second_word])
    #         end
    #       }
    #     }})
    #
    # @return [ActiveRecord::Relation]
    #
    # @note Switched from `scope` to class method because of a bug in Rails 3.2.1 where
    #   `joins_values` aren't available in scopes.
    #
    # @since 0.1.0
    included do
      extend WithFilters::HashExtraction
      def self.with_filters(params = nil, options = {})
        relation = self.scoped.extend(AddData).extending do
          def to_a
            a = super.extend(AddData)
            a.with_filters_data = self.with_filters_data
            a
          end
        end
        param_namespace = options.delete(:param_namespace) || relation.table_name.to_sym
        relation.with_filters_data = {
          param_namespace: param_namespace,
          column_types:    find_column_types(relation, options[:fields] || {})
        }

        scoped_params = params ? self.extract_hash_value(params, param_namespace) || {} : {}
        scoped_params.each do |field, value|
          # skip blank entries
          value.reject!{|v| v.blank?} if value.is_a?(Array)
          if (value.is_a?(String) and value.blank?) or
             (value.is_a?(Array) and value.empty?) or
             (value.is_a?(Hash) and not (value[:start].present? and value[:stop].present?))
            next
          end

          field_options = {}
          field_options = options[:fields][field] if options[:fields] and options[:fields][field]

          if field_options.is_a?(Proc)
            relation = field_options.call(value, relation)
          else
            db_column_table_name, db_column_name = (field_options.delete(:column) || field).to_s.split('.')
            if db_column_name.nil?
              db_column_name = db_column_table_name
              db_column_table_name = relation.column_names.include?(db_column_name) ? self.table_name : nil
            end

            quoted_field = relation.connection.quote_column_name(db_column_name)
            quoted_field = "#{db_column_table_name}.#{quoted_field}" if db_column_table_name

            value = WithFilters::ValuePrep.prepare(relation.with_filters_data[:column_types][field], value, field_options)

            # attach filter
            relation = case value.class.name.to_sym
              when :Array
                relation.where([Array.new(value.size, "#{quoted_field} LIKE ?").join(' OR '), *value])
              when :Hash
                if ![:datetime, :timestamp].include?(relation.with_filters_data[:column_types][field]) or Date._parse(value[:start])[:sec_fraction]
                  relation.where(["#{quoted_field} BETWEEN :start AND :stop", value])
                else
                  relation.where(["#{quoted_field} >= :start AND #{quoted_field} < :stop", value])
                end
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

    # @private
    module ClassMethods
      # @param [ActiveRecord::Relation] relation A relation to find the columns of.
      # @param [Hash] field_options
      #
      # @return [Hash<String>] A mapping of fields to their database types.
      #
      # @since 0.1.0
      def find_column_types(relation, field_options)
        field_options = field_options.reject{|k, v| v.is_a?(Proc)}

        # primary table column types
        column_types = Hash[*relation.columns.map{|column|
          [
            field_options.detect{|field, options|
              [column.name, "#{relation.table_name}.#{column.name}"].include?(options[:column].to_s)
            }.try(:first) || column.name.to_sym,
            column.type
          ]
        }.flatten]

        # non-primary table columns
        (relation.joins_values + relation.includes_values).uniq.map{|join|
          # convert string joins to table names
          if join.is_a?(String)
            join.scan(/\G(?:(?:,|\bjoin\s)\s*(\w+))/i)
          else
            join
          end 
        }.flatten.map do |table_name|
          ActiveRecord::Base::connection.columns(table_name.to_s.tableize).each do |column|
            column_name = field_options.detect{|field, options|
              [column.name, "#{table_name}.#{column.name}"].include?(options[:column].to_s)
            }.try(:first) || column.name.to_sym

            column_types.reverse_merge!(column_name => column.type)
          end
        end

        column_types
      end
    end
  end
end
