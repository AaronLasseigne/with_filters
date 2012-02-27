class CreateDateTimeTesters < ActiveRecord::Migration
  def up
    create_table :date_time_testers do |t|
      t.datetime :test
    end

    [
      '2012-01-01 00:00:01.000000',
      '2012-01-01 00:00:01.123456',
      '2012-01-01 00:00:01.654300',
      '2012-01-01 00:00:01.654321',
      '2012-01-01 00:00:02.000000',
      '2012-01-01 00:00:03.000000',
      '2012-01-01 00:00:03.100000',
      '2012-01-01 23:59:59.999999',
      '2012-01-02 00:00:00.000000'
    ].each do |time|
      DateTimeTester.create(test: time)
    end
  end

  def down
    drop_table :date_time_testers
  end
end
