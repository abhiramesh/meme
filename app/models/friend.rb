class Friend < ActiveRecord::Base
  attr_accessible :name, :uid, :user_id

  belongs_to :user
  has_many :photos, :foreign_key => :uid, :primary_key => :uid, dependent: :destroy

end
