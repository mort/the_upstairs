class PresencesController < ApplicationController
  before_filter :oauth_required
  log_activity_streams :current_user, :login, :enters_venue, :@venue, :title, :create,  :presence, {:total => 1 }        
  log_activity_streams :current_user, :login, :leaves_venue, :@venue, :title, :destroy, :presence, {:total => 1 }

  def create
    @venue = Venue.find(params[:venue_id])
    tile = @venue.tile

    when_in(tile) do |v| 
      current_user.presences.create(:venue_id => @venue.id)
      render :text => @venue.to_json, :status => 201 and return
    end
    
  end

  def destroy
    
    presence = current_user.presences.active.find_by_venue_id(params[:venue_id])
    
    @venue = presence.venue unless presence.nil?
      
    when_in(@venue.tile) {
      
      text,status = if presence.nil?
        ['', 404]
      else
        presence.finish!
        [@venue.to_json, 204]
      end

      render :text => text, :status => status    

    }  
    
  end
  
end
