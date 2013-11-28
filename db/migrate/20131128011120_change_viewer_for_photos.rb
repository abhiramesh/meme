class ChangeViewerForPhotos < ActiveRecord::Migration
  def up
  	remove_column :photos, :viewer_id
  	add_column :photos, :user_id, :integer
  end

  def down
  end
end
