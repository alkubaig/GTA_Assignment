class ChangeColsSection < ActiveRecord::Migration
  def change
 	  	   add_column :sections, :merge_dep, :string
  	  	   add_column :sections, :merge_num, :string
  	  	   add_column :sections, :merge_curr_num, :integer
  	  	   add_column :sections, :merge_max_num, :integer

  end
end
