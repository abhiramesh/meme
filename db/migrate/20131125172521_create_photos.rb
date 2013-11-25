class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :uid
      t.string :src

      t.timestamps
    end
    add_index :photos, :uid
  end
end
