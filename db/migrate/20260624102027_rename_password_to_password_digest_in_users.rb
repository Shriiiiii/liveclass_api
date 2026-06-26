class RenamePasswordToPasswordDigestInUsers < ActiveRecord::Migration[7.1]
  def change
    # rename_column :table_name, :old_column, :new_column
    rename_column :users, :password, :password_digest
  end
end