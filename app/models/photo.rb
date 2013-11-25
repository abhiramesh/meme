class Photo < ActiveRecord::Base
  attr_accessible :uid, :src

  belongs_to :friend, :foreign_key => :uid, :primary_key => :uid

end
