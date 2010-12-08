ActionController::Routing::Routes.draw do |map|



  map.resources :user_requests

 
  #map.namespace(:api) do |api| 
  
    map.resources :pings
    
    map.resource :me, :controler => :users do |me|
      me.resources :words
      me.resources :vcard_giving
    end
  
    map.resources :journeys, :member => {:stats => :get} do |journey|
      
      journey.resources :tiles, :member => {:look => :get, :feed => :get} do |tile|
        tile.resources :public_messages
      end
      
      journey.resources :pictures
      
      journey.resources :venues, :member => {:talk_to => :put} do |venue|
        venue.resource :presence
      end
      
      journey.resources :travelers, :member => {:talk_to => :put} do |traveler|
        traveler.resources :user_requests
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
#== Route Map
# Generated on 21 Oct 2010 10:36
#
#                  your_activities        /feeds/your_activities/:activity_stream_token                           {:action=>"feed", :format=>"atom", :controller=>"activity_streams"}
#      activity_stream_preferences GET    /activity_stream_preferences(.:format)                                  {:action=>"index", :controller=>"activity_stream_preferences"}
#                                  POST   /activity_stream_preferences(.:format)                                  {:action=>"create", :controller=>"activity_stream_preferences"}
#   new_activity_stream_preference GET    /activity_stream_preferences/new(.:format)                              {:action=>"new", :controller=>"activity_stream_preferences"}
#  edit_activity_stream_preference GET    /activity_stream_preferences/:id/edit(.:format)                         {:action=>"edit", :controller=>"activity_stream_preferences"}
#       activity_stream_preference GET    /activity_stream_preferences/:id(.:format)                              {:action=>"show", :controller=>"activity_stream_preferences"}
#                                  PUT    /activity_stream_preferences/:id(.:format)                              {:action=>"update", :controller=>"activity_stream_preferences"}
#                                  DELETE /activity_stream_preferences/:id(.:format)                              {:action=>"destroy", :controller=>"activity_stream_preferences"}
#                 activity_streams GET    /activity_streams(.:format)                                             {:action=>"index", :controller=>"activity_streams"}
#                                  POST   /activity_streams(.:format)                                             {:action=>"create", :controller=>"activity_streams"}
#              new_activity_stream GET    /activity_streams/new(.:format)                                         {:action=>"new", :controller=>"activity_streams"}
#             edit_activity_stream GET    /activity_streams/:id/edit(.:format)                                    {:action=>"edit", :controller=>"activity_streams"}
#                  activity_stream GET    /activity_streams/:id(.:format)                                         {:action=>"show", :controller=>"activity_streams"}
#                                  PUT    /activity_streams/:id(.:format)                                         {:action=>"update", :controller=>"activity_streams"}
#                                  DELETE /activity_streams/:id(.:format)                                         {:action=>"destroy", :controller=>"activity_streams"}
#                    user_requests GET    /user_requests(.:format)                                                {:action=>"index", :controller=>"user_requests"}
#                                  POST   /user_requests(.:format)                                                {:action=>"create", :controller=>"user_requests"}
#                 new_user_request GET    /user_requests/new(.:format)                                            {:action=>"new", :controller=>"user_requests"}
#                edit_user_request GET    /user_requests/:id/edit(.:format)                                       {:action=>"edit", :controller=>"user_requests"}
#                     user_request GET    /user_requests/:id(.:format)                                            {:action=>"show", :controller=>"user_requests"}
#                                  PUT    /user_requests/:id(.:format)                                            {:action=>"update", :controller=>"user_requests"}
#                                  DELETE /user_requests/:id(.:format)                                            {:action=>"destroy", :controller=>"user_requests"}
#                            pings GET    /pings(.:format)                                                        {:action=>"index", :controller=>"pings"}
#                                  POST   /pings(.:format)                                                        {:action=>"create", :controller=>"pings"}
#                         new_ping GET    /pings/new(.:format)                                                    {:action=>"new", :controller=>"pings"}
#                        edit_ping GET    /pings/:id/edit(.:format)                                               {:action=>"edit", :controller=>"pings"}
#                             ping GET    /pings/:id(.:format)                                                    {:action=>"show", :controller=>"pings"}
#                                  PUT    /pings/:id(.:format)                                                    {:action=>"update", :controller=>"pings"}
#                                  DELETE /pings/:id(.:format)                                                    {:action=>"destroy", :controller=>"pings"}
#     journey_tile_public_messages GET    /journeys/:journey_id/tiles/:tile_id/public_messages(.:format)          {:action=>"index", :controller=>"public_messages"}
#                                  POST   /journeys/:journey_id/tiles/:tile_id/public_messages(.:format)          {:action=>"create", :controller=>"public_messages"}
#  new_journey_tile_public_message GET    /journeys/:journey_id/tiles/:tile_id/public_messages/new(.:format)      {:action=>"new", :controller=>"public_messages"}
# edit_journey_tile_public_message GET    /journeys/:journey_id/tiles/:tile_id/public_messages/:id/edit(.:format) {:action=>"edit", :controller=>"public_messages"}
#      journey_tile_public_message GET    /journeys/:journey_id/tiles/:tile_id/public_messages/:id(.:format)      {:action=>"show", :controller=>"public_messages"}
#                                  PUT    /journeys/:journey_id/tiles/:tile_id/public_messages/:id(.:format)      {:action=>"update", :controller=>"public_messages"}
#                                  DELETE /journeys/:journey_id/tiles/:tile_id/public_messages/:id(.:format)      {:action=>"destroy", :controller=>"public_messages"}
#                    journey_tiles GET    /journeys/:journey_id/tiles(.:format)                                   {:action=>"index", :controller=>"tiles"}
#                                  POST   /journeys/:journey_id/tiles(.:format)                                   {:action=>"create", :controller=>"tiles"}
#                 new_journey_tile GET    /journeys/:journey_id/tiles/new(.:format)                               {:action=>"new", :controller=>"tiles"}
#                edit_journey_tile GET    /journeys/:journey_id/tiles/:id/edit(.:format)                          {:action=>"edit", :controller=>"tiles"}
#                look_journey_tile GET    /journeys/:journey_id/tiles/:id/look(.:format)                          {:action=>"look", :controller=>"tiles"}
#                feed_journey_tile GET    /journeys/:journey_id/tiles/:id/feed(.:format)                          {:action=>"feed", :controller=>"tiles"}
#                     journey_tile GET    /journeys/:journey_id/tiles/:id(.:format)                               {:action=>"show", :controller=>"tiles"}
#                                  PUT    /journeys/:journey_id/tiles/:id(.:format)                               {:action=>"update", :controller=>"tiles"}
#                                  DELETE /journeys/:journey_id/tiles/:id(.:format)                               {:action=>"destroy", :controller=>"tiles"}
#                 journey_pictures GET    /journeys/:journey_id/pictures(.:format)                                {:action=>"index", :controller=>"pictures"}
#                                  POST   /journeys/:journey_id/pictures(.:format)                                {:action=>"create", :controller=>"pictures"}
#              new_journey_picture GET    /journeys/:journey_id/pictures/new(.:format)                            {:action=>"new", :controller=>"pictures"}
#             edit_journey_picture GET    /journeys/:journey_id/pictures/:id/edit(.:format)                       {:action=>"edit", :controller=>"pictures"}
#                  journey_picture GET    /journeys/:journey_id/pictures/:id(.:format)                            {:action=>"show", :controller=>"pictures"}
#                                  PUT    /journeys/:journey_id/pictures/:id(.:format)                            {:action=>"update", :controller=>"pictures"}
#                                  DELETE /journeys/:journey_id/pictures/:id(.:format)                            {:action=>"destroy", :controller=>"pictures"}
#       new_journey_venue_presence GET    /journeys/:journey_id/venues/:venue_id/presence/new(.:format)           {:action=>"new", :controller=>"presences"}
#      edit_journey_venue_presence GET    /journeys/:journey_id/venues/:venue_id/presence/edit(.:format)          {:action=>"edit", :controller=>"presences"}
#           journey_venue_presence GET    /journeys/:journey_id/venues/:venue_id/presence(.:format)               {:action=>"show", :controller=>"presences"}
#                                  PUT    /journeys/:journey_id/venues/:venue_id/presence(.:format)               {:action=>"update", :controller=>"presences"}
#                                  DELETE /journeys/:journey_id/venues/:venue_id/presence(.:format)               {:action=>"destroy", :controller=>"presences"}
#                                  POST   /journeys/:journey_id/venues/:venue_id/presence(.:format)               {:action=>"create", :controller=>"presences"}
#                   journey_venues GET    /journeys/:journey_id/venues(.:format)                                  {:action=>"index", :controller=>"venues"}
#                                  POST   /journeys/:journey_id/venues(.:format)                                  {:action=>"create", :controller=>"venues"}
#                new_journey_venue GET    /journeys/:journey_id/venues/new(.:format)                              {:action=>"new", :controller=>"venues"}
#               edit_journey_venue GET    /journeys/:journey_id/venues/:id/edit(.:format)                         {:action=>"edit", :controller=>"venues"}
#                    journey_venue GET    /journeys/:journey_id/venues/:id(.:format)                              {:action=>"show", :controller=>"venues"}
#                                  PUT    /journeys/:journey_id/venues/:id(.:format)                              {:action=>"update", :controller=>"venues"}
#                                  DELETE /journeys/:journey_id/venues/:id(.:format)                              {:action=>"destroy", :controller=>"venues"}
#               journey_feed_items GET    /journeys/:journey_id/feed(.:format)                                    {:action=>"index", :controller=>"feed_items"}
#                                  POST   /journeys/:journey_id/feed(.:format)                                    {:action=>"create", :controller=>"feed_items"}
#            new_journey_feed_item GET    /journeys/:journey_id/feed/new(.:format)                                {:action=>"new", :controller=>"feed_items"}
#           edit_journey_feed_item GET    /journeys/:journey_id/feed/:id/edit(.:format)                           {:action=>"edit", :controller=>"feed_items"}
#                journey_feed_item GET    /journeys/:journey_id/feed/:id(.:format)                                {:action=>"show", :controller=>"feed_items"}
#                                  PUT    /journeys/:journey_id/feed/:id(.:format)                                {:action=>"update", :controller=>"feed_items"}
#                                  DELETE /journeys/:journey_id/feed/:id(.:format)                                {:action=>"destroy", :controller=>"feed_items"}
#                         journeys GET    /journeys(.:format)                                                     {:action=>"index", :controller=>"journeys"}
#                                  POST   /journeys(.:format)                                                     {:action=>"create", :controller=>"journeys"}
#                      new_journey GET    /journeys/new(.:format)                                                 {:action=>"new", :controller=>"journeys"}
#                     edit_journey GET    /journeys/:id/edit(.:format)                                            {:action=>"edit", :controller=>"journeys"}
#                    stats_journey GET    /journeys/:id/stats(.:format)                                           {:action=>"stats", :controller=>"journeys"}
#                          journey GET    /journeys/:id(.:format)                                                 {:action=>"show", :controller=>"journeys"}
#                                  PUT    /journeys/:id(.:format)                                                 {:action=>"update", :controller=>"journeys"}
#                                  DELETE /journeys/:id(.:format)                                                 {:action=>"destroy", :controller=>"journeys"}
#                    oauth_clients GET    /oauth_clients(.:format)                                                {:action=>"index", :controller=>"oauth_clients"}
#                                  POST   /oauth_clients(.:format)                                                {:action=>"create", :controller=>"oauth_clients"}
#                 new_oauth_client GET    /oauth_clients/new(.:format)                                            {:action=>"new", :controller=>"oauth_clients"}
#                edit_oauth_client GET    /oauth_clients/:id/edit(.:format)                                       {:action=>"edit", :controller=>"oauth_clients"}
#                     oauth_client GET    /oauth_clients/:id(.:format)                                            {:action=>"show", :controller=>"oauth_clients"}
#                                  PUT    /oauth_clients/:id(.:format)                                            {:action=>"update", :controller=>"oauth_clients"}
#                                  DELETE /oauth_clients/:id(.:format)                                            {:action=>"destroy", :controller=>"oauth_clients"}
#                     test_request        /oauth/test_request                                                     {:action=>"test_request", :controller=>"oauth"}
#                     access_token        /oauth/access_token                                                     {:action=>"access_token", :controller=>"oauth"}
#                    request_token        /oauth/request_token                                                    {:action=>"request_token", :controller=>"oauth"}
#                        authorize        /oauth/authorize                                                        {:action=>"authorize", :controller=>"oauth"}
#                            oauth        /oauth                                                                  {:action=>"index", :controller=>"oauth"}
#                 new_user_session GET    /user_session/new(.:format)                                             {:action=>"new", :controller=>"user_sessions"}
#                edit_user_session GET    /user_session/edit(.:format)                                            {:action=>"edit", :controller=>"user_sessions"}
#                     user_session GET    /user_session(.:format)                                                 {:action=>"show", :controller=>"user_sessions"}
#                                  PUT    /user_session(.:format)                                                 {:action=>"update", :controller=>"user_sessions"}
#                                  DELETE /user_session(.:format)                                                 {:action=>"destroy", :controller=>"user_sessions"}
#                                  POST   /user_session(.:format)                                                 {:action=>"create", :controller=>"user_sessions"}
#                             root        /                                                                       {:action=>"new", :controller=>"user_sessions"}
#                      new_account GET    /account/new(.:format)                                                  {:action=>"new", :controller=>"users"}
#                     edit_account GET    /account/edit(.:format)                                                 {:action=>"edit", :controller=>"users"}
#                          account GET    /account(.:format)                                                      {:action=>"show", :controller=>"users"}
#                                  PUT    /account(.:format)                                                      {:action=>"update", :controller=>"users"}
#                                  DELETE /account(.:format)                                                      {:action=>"destroy", :controller=>"users"}
#                                  POST   /account(.:format)                                                      {:action=>"create", :controller=>"users"}
#               user_user_requests GET    /users/:user_id/user_requests(.:format)                                 {:action=>"index", :controller=>"user_requests"}
#                                  POST   /users/:user_id/user_requests(.:format)                                 {:action=>"create", :controller=>"user_requests"}
#            new_user_user_request GET    /users/:user_id/user_requests/new(.:format)                             {:action=>"new", :controller=>"user_requests"}
#         accept_user_user_request PUT    /users/:user_id/user_requests/:id/accept(.:format)                      {:action=>"accept", :controller=>"user_requests"}
#        decline_user_user_request PUT    /users/:user_id/user_requests/:id/decline(.:format)                     {:action=>"decline", :controller=>"user_requests"}
#           edit_user_user_request GET    /users/:user_id/user_requests/:id/edit(.:format)                        {:action=>"edit", :controller=>"user_requests"}
#                user_user_request GET    /users/:user_id/user_requests/:id(.:format)                             {:action=>"show", :controller=>"user_requests"}
#                                  PUT    /users/:user_id/user_requests/:id(.:format)                             {:action=>"update", :controller=>"user_requests"}
#                                  DELETE /users/:user_id/user_requests/:id(.:format)                             {:action=>"destroy", :controller=>"user_requests"}
#                            users GET    /users(.:format)                                                        {:action=>"index", :controller=>"users"}
#                                  POST   /users(.:format)                                                        {:action=>"create", :controller=>"users"}
#                         new_user GET    /users/new(.:format)                                                    {:action=>"new", :controller=>"users"}
#                        edit_user GET    /users/:id/edit(.:format)                                               {:action=>"edit", :controller=>"users"}
#                             user GET    /users/:id(.:format)                                                    {:action=>"show", :controller=>"users"}
#                                  PUT    /users/:id(.:format)                                                    {:action=>"update", :controller=>"users"}
#                                  DELETE /users/:id(.:format)                                                    {:action=>"destroy", :controller=>"users"}
