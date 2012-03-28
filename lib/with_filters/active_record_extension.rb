module WithFilters
  # @private
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      class << self
        alias_method_chain :inherited, :with_filters
      end

      # Attach the ActiveRecord extensions to children of ActiveRecord that were initiated before we loaded WithFilters.
      self.descendants.each do |descendant|
        descendant.send(:include, WithFilters::ActiveRecordModelExtension) if descendant.superclass == ActiveRecord::Base
      end
    end

    # @private
    module ClassMethods
      # Attaches the ActiveRecord extensions to children of ActiveRecord so we don't pollute ActiveRecord::Base.
      def inherited_with_with_filters(base)
        inherited_without_with_filters(base)
        base.send(:include, WithFilters::ActiveRecordModelExtension) if base.superclass == ActiveRecord::Base
      end
    end
  end
end
