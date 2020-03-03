class CreateKeepUsers < ActiveRecord::Migration
  def change
    create_table :keep_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :role
      t.string :email
      t.float :fte
      t.string :cc_instructor_tag

      t.timestamps null: false
    end
  end
end
