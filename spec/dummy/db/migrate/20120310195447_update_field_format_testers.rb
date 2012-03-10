class UpdateFieldFormatTesters < ActiveRecord::Migration
  def up
    add_column :field_format_testers, :string_field, :string
    change_column :field_format_testers, :email_field, :string
    change_column :field_format_testers, :phone_field, :string
    change_column :field_format_testers, :url_field, :string
  end

  def down
    change_column :field_format_testers, :email_field, :text
    change_column :field_format_testers, :phone_field, :text
    change_column :field_format_testers, :url_field, :text
    remove_column :field_format_testers, :string_field
  end
end
