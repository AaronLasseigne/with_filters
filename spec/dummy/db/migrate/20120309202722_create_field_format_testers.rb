class CreateFieldFormatTesters < ActiveRecord::Migration
  def change
    create_table :field_format_testers do |t|
      t.integer   :integer_field
      t.float     :float_field
      t.decimal   :decimal_field
      t.date      :date_field
      t.time      :time_field
      t.datetime  :datetime_field
      t.timestamp :timestamp_field
      t.boolean   :boolean_field
      t.text      :text_field
      t.text      :email_field
      t.text      :phone_field
      t.text      :url_field
    end

    remove_column :nobel_prize_winners, :meaningless_time
    remove_column :nobel_prizes, :meaningless_decimal
    remove_column :nobel_prizes, :meaningless_float
  end
end
