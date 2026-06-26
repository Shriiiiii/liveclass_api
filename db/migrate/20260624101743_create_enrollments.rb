class CreateEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :live_class, null: false, foreign_key: true
      t.datetime :enrolled_at

      t.timestamps
    end
  end
end
