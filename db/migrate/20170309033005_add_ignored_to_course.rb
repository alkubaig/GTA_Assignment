class AddIgnoredToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :ignored, :bool, :default => false
  end
end
