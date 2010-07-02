class PresencesController < ApplicationController
  
  before_filter :oauth_required
  before_filter :fetch_venue
  
  log_activity_streams :current_user, :login, :enters_venue, :@venue, :title, :create,  :presence, {:total => 1 }        
  log_activity_streams :current_user, :login, :leaves_venue, :@venue, :title, :destroy, :presence, {:total => 1 }


  def create
    tile = @venue.tile
    
    when_in(tile) {
      current_user.presences.create(:venue_id => @venue.id)
      render :text => @venue.to_json, :status => 201 
    }
  end

  def destroy 
    when_in(@venue) {
      current_user.current_presence.finish!
      render :text => @venue.to_json, :status =>  204
    }
  end
  
  private
  
  def fetch_venue
    @venue = Venue.find(params[:venue_id])
  end
  
end
