class AddCapacityToLiveClasses < ActiveRecord::Migration[8.1]
  def change
    add_column :live_classes, :capacity, :integer
  end
end
