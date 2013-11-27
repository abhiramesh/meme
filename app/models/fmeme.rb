class Fmeme < ActiveRecord::Base
  attr_accessible :photo_id, :url, :user_id, :uid

  belongs_to :user
  belongs_to :photo

end
