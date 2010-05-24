class PingsController < ApplicationController
  
  def create
    user = User.find(params[:user_id])
    ping = user.pings.create(:lat => params[:lat], :lon => params[:lon])    
    position = ping.position
    journey = user.ongoing_journey
    redirect_to(map_journey_tile_url(journey, position.tile, :format => :json))
  end
end
