class PingsController < ApplicationController
  
  def create
    user = User.find(params[:user_id])
    ping = user.pings.create(:lat => params[:lat], :lon => params[:lon])
    
    position = ping.position
    redirect_to tile_url(position.tile)
    
  end
end
