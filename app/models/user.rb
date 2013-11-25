class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :provider, :oauth_token, :oauth_expires_at, :uid, :profile_image
  

  def facebook
    @facebook ||= Koala::Facebook::API.new(self.oauth_token)
  end

end
