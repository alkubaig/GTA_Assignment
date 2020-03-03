class AddDetailsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :ta_major, :string
  end
end
