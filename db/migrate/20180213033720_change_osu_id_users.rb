class ChangeOsuIdUsers < ActiveRecord::Migration
  def change
  	    change_column :users, :osu_id, :int, null: true

  end
end
