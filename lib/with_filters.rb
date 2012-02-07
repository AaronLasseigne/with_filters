require 'with_filters/engine'
require 'with_filters/active_record_extension'
require 'with_filters/active_record_model_extension'
require 'with_filters/version'

ActiveSupport.on_load(:active_record) do
  include WithFilters::ActiveRecordExtension
end
