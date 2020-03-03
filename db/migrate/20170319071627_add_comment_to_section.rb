class AddCommentToSection < ActiveRecord::Migration
  def change
    add_column :sections, :comment, :text
  end
end
