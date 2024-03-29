Meme::Application.routes.draw do
  

  resources :friends
  resources :photos

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" } do
    get '/users/auth/facebook', :to => "omniauth_callbacks#facebook", :as => "user_omniauth_authorize"
  end

  devise_scope :user do
    get '/logout', :to => "devise/sessions#destroy", :as => "logout"
  end

  authenticated :user do
    root :to => "photos#index"
  end 

  resources :users

  root :to => "static_pages#home"

  get '/all_photos', :to => "photos#index"
  get '/check_count', :to => "photos#check_count"

  get '/new_meme', :to => "photos#new_meme"

  post '/save_meme', :to => "fmemes#create"

  get '/fmemes/:id', :to => "fmemes#show", :as => "show_meme"

  get '/fmemes', :to => "fmemes#index"

  get '/memes_of_me', :to => "fmemes#memes_of_me"

  match '/results', :to => "photos#search_results", :as => "friend_search"
  match '/share_with_friend', :to => "fmemes#share_with_friend", :as => "share_with_friend"

  get '/get_friends', :to => "friends#get_friends"



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
