class CreateCoursesWhiteLists < ActiveRecord::Migration
  def change
    create_table :courses_white_lists do |t|
      t.string :department
      t.integer :courseNumber

      t.timestamps null: false
    end
  end
end
