class AddCrossListedFlagToSection < ActiveRecord::Migration
  def change
    add_column :sections, :show, :bool, :default => true
  end
end
