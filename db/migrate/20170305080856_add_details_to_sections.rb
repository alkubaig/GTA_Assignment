class AddDetailsToSections < ActiveRecord::Migration
  def change
    add_column :sections, :num_lab, :integer, :default => 0
  end
end
