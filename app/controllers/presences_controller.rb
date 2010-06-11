class PresencesController < ApplicationController
  before_filter :oauth_required
  before_filter :validate_request
  
  log_activity_streams :current_user, :login, :enters_venue, :@venue, :title, :create,  :presence, {:total => 1 }        
  log_activity_streams :current_user, :login, :leaves_venue, :@venue, :title, :destroy, :presence, {:total => 1 }

  def create
    @venue = Venue.find(params[:venue_id])
    current_user.presences.create(:venue_id => @venue.id)
    render :text => '', :status => 201
  end

  def destroy
    
    presence = current_user.presences.active.find_by_venue_id(params[:venue_id])
    
    status = if presence.nil?
      404
    else
      @venue = presence.venue
      presence.finish!
      204
    end

    render :text => '', :status => status    
  end
  
  private
  
  def validate_request
    true
    #return false unless current_user.in_journey?(params[:journey_id]) && current_user.in_tile()
  end

end
