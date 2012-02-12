require 'with_filters/engine'
require 'with_filters/active_record_extension'
require 'with_filters/active_record_model_extension'
require 'with_filters/value_prep/default_prep'
require 'with_filters/value_prep/boolean_prep'
require 'with_filters/value_prep/date_prep'
require 'with_filters/value_prep/date_time_prep'
require 'with_filters/value_prep/string_prep'
require 'with_filters/value_prep/value_prep'
require 'with_filters/version'

ActiveSupport.on_load(:active_record) do
  include WithFilters::ActiveRecordExtension
end
