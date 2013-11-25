class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :user_id
      t.string :uid
      t.string :name

      t.timestamps
    end
    add_index :friends, :user_id
  end
end
