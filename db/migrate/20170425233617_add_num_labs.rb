class AddNumLabs < ActiveRecord::Migration
  def change
  	   add_column :sections, :num_labs, :integer, :default => 0
  end
end
