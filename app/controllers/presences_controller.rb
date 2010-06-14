class PresencesController < ApplicationController
  before_filter :oauth_required
  log_activity_streams :current_user, :login, :enters_venue, :@venue, :title, :create,  :presence, {:total => 1 }        
  log_activity_streams :current_user, :login, :leaves_venue, :@venue, :title, :destroy, :presence, {:total => 1 }

  def create
    @venue = Venue.find(params[:venue_id])
    verify_in_tile(@venue.tile)
    current_user.presences.create(:venue_id => @venue.id)
    render :text => @venue.to_json, :status => 201
  end

  def destroy
    
    presence = current_user.presences.active.find_by_venue_id(params[:venue_id])
    
    unless presence.nil?
      @venue = presence.venue
      verify_in_tile(@venue.tile)  
    end
    
    text,status = if presence.nil?
      ['', 404]
    else
      presence.finish!
      [@venue.to_json, 204]
    end

    render :text => text, :status => status    
  end
  
end
