class AddIgnoredToCoursesWhiteLists < ActiveRecord::Migration
  def change
    add_column :courses_white_lists, :ignored, :bool
  end
end
