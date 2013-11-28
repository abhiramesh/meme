class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :provider, :oauth_token, :oauth_expires_at, :uid, :profile_image
	
  has_many :friends, dependent: :destroy
  has_many :photos
  has_many :fmemes, dependent: :destroy

  def facebook
    @facebook ||= Koala::Facebook::API.new(self.oauth_token)
  end

  def post_to_friend_wall(fmeme)
		friend = Friend.find_by_uid(fmeme.uid)
		photo = self.facebook.put_picture(fmeme.url.to_s, {:message => "I made a hilarious meme of #{friend.name} - Make memes of your friends at http://www.mememyfriends.com" })
  		photo_id = photo["id"]
		self.facebook.put_connections(photo_id,'tags',{'to' => friend.uid})
  end


  def get_my_friends_and_photos
  	if self.facebook
	  	f = self.facebook.fql_multiquery({"myfriends" => "SELECT name,uid FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me())", "myphotos" => "SELECT src_big,owner FROM photo WHERE aid IN (SELECT aid FROM album WHERE owner=me() AND name='Profile Pictures')"})
	  	if f
	  		my_array = JSON.parse(f.to_json)
	  		if my_array
		  		friends_hash = my_array["myfriends"]
		  		myphotos_hash = my_array["myphotos"]
		  		if friends_hash
			    	inserts = []
				    friends_hash.map { |d| inserts.push "(#{ActiveRecord::Base.sanitize(self.id)}, #{ActiveRecord::Base.sanitize(d["name"])}, #{ActiveRecord::Base.sanitize(d["uid"])}, #{ActiveRecord::Base.sanitize(Time.now.utc.to_s(:db))}, #{ActiveRecord::Base.sanitize(Time.now.utc.to_s(:db))})" }
				    begin
				    Friend.connection.execute "INSERT INTO friends (user_id, name, uid, created_at, updated_at) values #{inserts.join(", ")}"
					rescue
					end
				end
				if myphotos_hash
					inserts = []
				    myphotos_hash.map { |d| inserts.push "(#{ActiveRecord::Base.sanitize(self.id)}, #{ActiveRecord::Base.sanitize(d["src_big"])}, #{ActiveRecord::Base.sanitize(d["owner"])}, #{ActiveRecord::Base.sanitize(Time.now.utc.to_s(:db))}, #{ActiveRecord::Base.sanitize(Time.now.utc.to_s(:db))})" }
				    begin
				    Photo.connection.execute "INSERT INTO photos (user_id, src, uid, created_at, updated_at) values #{inserts.join(", ")}"
					rescue
					end
				end
		  	end
	  	end
  	end
  end

  def get_my_friendphotos
  	if self.facebook
	  	var = 0
	  	loop do
	  		g = self.facebook.fql_query("SELECT src_big,owner FROM photo WHERE aid IN (SELECT aid FROM album WHERE owner IN (SELECT uid2 FROM friend WHERE uid1=me() LIMIT 50 OFFSET #{var}) AND name='Profile Pictures')")
			if g
				inserts = []
				g.map { |d| inserts.push "(#{ActiveRecord::Base.sanitize(self.id)}, #{ActiveRecord::Base.sanitize(d["src_big"])}, #{ActiveRecord::Base.sanitize(d["owner"])}, #{ActiveRecord::Base.sanitize(Time.now.utc.to_s(:db))}, #{ActiveRecord::Base.sanitize(Time.now.utc.to_s(:db))})" }
				begin
				Photo.connection.execute "INSERT INTO photos (user_id, src, uid, created_at, updated_at) values #{inserts.join(", ")}"
				rescue
				end
			end
			break g unless g != []
	  		var +=50
	  	end
	end
  end

  	

end
