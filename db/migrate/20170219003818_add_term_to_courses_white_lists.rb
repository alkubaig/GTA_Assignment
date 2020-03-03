class AddTermToCoursesWhiteLists < ActiveRecord::Migration
  def change
    add_column :courses_white_lists, :term, :string
  end
end
