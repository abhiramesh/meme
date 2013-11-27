class AddUidToFmemes < ActiveRecord::Migration
  def change
    add_column :fmemes, :uid, :string
  end
end
