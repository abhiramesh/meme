class AddViewerIdToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :viewer_id, :integer
  end
end
