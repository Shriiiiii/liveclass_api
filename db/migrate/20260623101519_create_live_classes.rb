class CreateLiveClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :live_classes do |t|
      t.string :subject
      t.string :trainer
      t.string :status

      t.timestamps
    end
  end
end
