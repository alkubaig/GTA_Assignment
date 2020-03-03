class AddDetailsToSection < ActiveRecord::Migration
  def change
    add_column :sections, :honor, :bool, :default => false
  end
end
