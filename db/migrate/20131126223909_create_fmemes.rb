class CreateFmemes < ActiveRecord::Migration
  def change
    create_table :fmemes do |t|
      t.string :url
      t.integer :photo_id
      t.integer :user_id

      t.timestamps
    end
    add_index :fmemes, :photo_id
    add_index :fmemes, :user_id
  end
end
