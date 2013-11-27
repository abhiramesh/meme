class OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def facebook
		omniauth = request.env["omniauth.auth"]
		omniauth['extra']['raw_info']['email'] ? email =  omniauth['extra']['raw_info']['email'] : email = ''
		omniauth['extra']['raw_info']['name'] ? name =  omniauth['extra']['raw_info']['name'] : name = ''
		omniauth['extra']['raw_info']['id'] ?  uid =  omniauth['extra']['raw_info']['id'] : uid = ''
		omniauth['provider'] ? provider =  omniauth['provider'] : provider = ''
		omniauth['credentials']['token'] ? oauth_token =  omniauth['credentials']['token'] : oauth_token = ''
		omniauth['credentials']['expires_at'] ? oauth_expires_at = omniauth['credentials']['expires_at'] : oauth_expires_at = ''
		
		user = User.where(email: email).first
		if user
			user.oauth_token = omniauth['credentials']['token']
			user.save!
			if @fmeme = Fmeme.where(id: params["state"].to_i).first
				sign_in user
				user.delay.post_to_friend_wall(@fmeme)
				redirect_to show_meme_path(@fmeme), :flash => { :notice => "Successfully posted to your wall." }
			else
			sign_in_and_redirect user
			end
		else
			new_user = User.create(email: email, name: name, password: Devise.friendly_token, provider: provider, oauth_token: oauth_token, oauth_expires_at: oauth_expires_at, uid: uid)
			graph = new_user.facebook
			if new_user.save
			    if graph
			      g = graph.fql_query("SELECT url FROM square_profile_pic WHERE id = me() AND size=200")
			      g = JSON.parse(g.to_json)
			      image = g[0]["url"]
			      new_user.profile_image = image
			      new_user.save!
			    end
			    sign_in new_user
			    new_user.get_my_friends_and_photos
			    new_user.delay(:queue => 'friends_' + new_user.id.to_s).get_my_friendphotos
			    redirect_to '/all_photos'
			else
				redirect_to root_path
			end
		end
	end

end
