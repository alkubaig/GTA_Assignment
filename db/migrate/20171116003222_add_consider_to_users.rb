class AddConsiderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :consider, :bool,:default => true
  end
end
