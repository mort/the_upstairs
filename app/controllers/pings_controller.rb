class PingsController < ApplicationController
  before_filter :oauth_required
  
  log_activity_streams :current_user, :login, :enters_tile, 
          :@tile, :geohash, :create, :movement, {:total => 1 }
  
  def create
    user = current_user
    ping = user.pings.create(:lat => params[:lat], :lon => params[:lon])    
    position = ping.position
    journey = user.ongoing_journey
    @tile = position.tile
    redirect_to(journey_tile_url(journey, @tile, :format => :json))
  end
end
