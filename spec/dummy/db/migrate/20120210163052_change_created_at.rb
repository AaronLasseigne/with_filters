class ChangeCreatedAt < ActiveRecord::Migration
  def up
    day = 1
    NobelPrizeWinner.all.in_groups(3, false) do |group|
      seconds = 1
      group.each do |npw|
        npw.update_attribute(:created_at, "201201#{'%02i' % day}1201#{'%02i' % seconds}")
        seconds += 1
      end

      day += 1
    end
  end

  def down
  end
end
