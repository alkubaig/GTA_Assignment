class RemoveConsiderToSections < ActiveRecord::Migration
  def change
    remove_column :sections, :consider, :bool
  end
end
