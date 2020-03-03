class AddConsiderToSections < ActiveRecord::Migration
  def change
    add_column :sections, :consider, :bool, :default => true
  end
end
