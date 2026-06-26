class FixSessionKeyTypoInUsers < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :sesession_key, :session_key
  end
end
