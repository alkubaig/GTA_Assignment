class AddDouble < ActiveRecord::Migration
  def change
  	  add_column :problems, :allow_double_ass, :bool, :default => false
  end
end
