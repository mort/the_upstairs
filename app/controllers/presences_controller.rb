class PresencesController < ApplicationController
  
  before_filter :oauth_required
  before_filter :fetch_venue
  
  log_activity_streams :current_user, :login, :enters_venue, :@venue, :title, :create,  :presence, {:total => 1 }        
  log_activity_streams :current_user, :login, :leaves_venue, :@venue, :title, :destroy, :presence, {:total => 1 }


  def create
    
    presence = current_user.presences.create(:venue_id => @venue.id)
    
    opt = (presence.new_record? ? {:text => @presence.errors.to_json, :status => 400} : {:text => @venue.to_json, :status => 201 })
    
    render opt
    
  end

  def destroy 
    
    presence = current_user.current_presence.destroy
  
    opt = presence.errors.blank? ? {:text => @venue.to_json, :status =>  204} : {:text => presence.errors.to_json, :status => 400}
    
    render opt
    
  end
  
  private
  
  def fetch_venue
    @venue = Venue.find(params[:venue_id])
  end
  
end
