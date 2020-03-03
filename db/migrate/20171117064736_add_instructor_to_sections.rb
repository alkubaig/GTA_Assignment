class AddInstructorToSections < ActiveRecord::Migration
  def change
    add_column :sections, :instructor_id, :int
  end
end
