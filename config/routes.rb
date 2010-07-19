ActionController::Routing::Routes.draw do |map|
  map.resources :user_requests

 
  #map.namespace(:api) do |api| 
    map.resources :pings
    map.resources :journeys, :member => {:stats => :get} do |journey|
      journey.resources :tiles, :member => {:look => :get, :feed => :get} do |tile|
        tile.resources :public_messages
      end
      journey.resources :pictures
      journey.resources :venues do |venue|
        venue.resource :presence
      end
    
      journey.resources :feed_items, :as => 'feed'
    end 
    

  #end
  
  ## OAUTH
  
  map.resources :oauth_clients
  map.test_request '/oauth/test_request', :controller => 'oauth', :action => 'test_request'
  map.access_token '/oauth/access_token', :controller => 'oauth', :action => 'access_token'
  map.request_token '/oauth/request_token', :controller => 'oauth', :action => 'request_token'
  map.authorize '/oauth/authorize', :controller => 'oauth', :action => 'authorize'
  map.oauth '/oauth', :controller => 'oauth', :action => 'index'
  
  # AUTHENTICATION
  
  map.resource :user_session
  map.root :controller => "user_sessions", :action => "new" # optional, this just sets the root route
  map.resource :account, :controller => "users"

  map.resources :users do |user|
    user.resources :user_requests, :member => {:accept => :put, :decline => :put}
  end

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
