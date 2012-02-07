module WithFilters
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    included do
      class << self
        alias_method_chain :inherited, :with_filters
      end

      self.descendants.each do |descendant|
        descendant.send(:include, WithFilters::ActiveRecordModelExtension) if descendant.superclass == ActiveRecord::Base
      end
    end

    module ClassMethods
      def inherited_with_with_filters(base)
        inherited_without_with_filters(base)
        base.send(:include, WithFilters::ActiveRecordModelExtension) if base.superclass == ActiveRecord::Base
      end
    end
  end
end
