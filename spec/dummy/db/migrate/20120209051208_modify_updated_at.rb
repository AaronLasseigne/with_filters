class ModifyUpdatedAt < ActiveRecord::Migration
  def up
    NobelPrizeWinner.all.each_with_index do |npw, i|
      npw.update_attribute(:updated_at, npw.updated_at.advance(seconds: i))
    end
  end

  def down
    NobelPrizeWinner.all.each do |npw|
      npw.update_attribute(:updated_at, npw.created_at)
    end
  end
end
