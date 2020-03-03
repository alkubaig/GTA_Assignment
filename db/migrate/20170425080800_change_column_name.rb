class ChangeColumnName < ActiveRecord::Migration
  def change
  	    rename_column :requirements, :course_id, :section_id
  end
end
