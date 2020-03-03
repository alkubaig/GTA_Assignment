class AddIsWaitListToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_wait_list, :boolean
  end
end
