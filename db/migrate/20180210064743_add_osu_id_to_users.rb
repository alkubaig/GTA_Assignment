class AddOsuIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :osu_id, :int#, null: false
  end
end
