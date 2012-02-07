module WithFilters
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      self.scope :with_filters, ->(params) {}
    end
  end
end
