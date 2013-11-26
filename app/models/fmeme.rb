class Fmeme < ActiveRecord::Base
  attr_accessible :photo_id, :url, :user_id

  belongs_to :user
  belongs_to :photo

end
