class AddValueToVotes < ActiveRecord::Migration
  def up
    add_column :votes, :value, :integer
    Vote.find_each do |vote|
      vote.value = vote.positive? ? 1 : -1
      vote.save
    end
    remove_column :votes, :positive
  end

  def down
    remove_column :votes, :value
    Vote.find_each do |vote|
      vote.positive = vote.value > 0
      vote.save
    end
    add_column :votes, :positive, :boolean
  end
end
