class Photo < ActiveRecord::Base
  attr_accessible :uid, :src, :viewer_id, :user_id

  belongs_to :friend, :foreign_key => :uid, :primary_key => :uid
  belongs_to :user
  has_many :memes, dependent: :destroy

end
