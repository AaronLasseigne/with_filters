class FixEinstein < ActiveRecord::Migration
  def up
    npw = NobelPrizeWinner.find_by_first_name('Albert')
    npw.update_attribute(:last_name, 'Einstein')
  end

  def down
  end
end
