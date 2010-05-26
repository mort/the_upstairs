class PingsController < ApplicationController
  log_activity_streams :current_user, :login, :enter_tile, 
          :@tile, :geohash, :create, :movement, {:total => 1 }
  
  def create
    user = User.find(params[:user_id])
    ping = user.pings.create(:lat => params[:lat], :lon => params[:lon])    
    position = ping.position
    journey = user.ongoing_journey
    @tile = position.tile
    redirect_to(journey_tile_url(journey, @tile, :format => :json))
  end
end
