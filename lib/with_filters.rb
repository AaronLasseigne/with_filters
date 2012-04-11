require 'with_filters/engine'
require 'with_filters/hash_extraction'
require 'with_filters/active_record_extension'
require 'with_filters/active_record_model_extension'
require 'with_filters/value_prep/default_prep'
require 'with_filters/value_prep/boolean_prep'
require 'with_filters/value_prep/date_prep'
require 'with_filters/value_prep/date_time_prep'
require 'with_filters/value_prep/value_prep'
require 'with_filters/action_view_extension'
require 'with_filters/models/action'
require 'with_filters/models/filter/choice'
require 'with_filters/models/filter/collection'
require 'with_filters/models/filter/base'
require 'with_filters/models/filter/base_range'
require 'with_filters/models/filter/text'
require 'with_filters/models/filter/text_range'
require 'with_filters/models/filter/radio'
require 'with_filters/models/filter/select'
require 'with_filters/models/filter/select_range'
require 'with_filters/models/filter/check_box'
require 'with_filters/models/filter/filter'
require 'with_filters/models/filter_form'
require 'with_filters/version'

ActiveSupport.on_load(:active_record) do
  include WithFilters::ActiveRecordExtension
end

ActiveSupport.on_load(:action_view) do
  include WithFilters::ActionViewExtension
end
