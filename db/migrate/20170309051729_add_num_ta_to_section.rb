class AddNumTaToSection < ActiveRecord::Migration
  def change
    add_column :sections, :num_ta, :integer, :default => 0
  end
end
