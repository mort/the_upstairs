class VenuesController < FeaturesController

  def checkin
    current_user.presences.create(:venue_id => params[:id])
    
    render :text => '', :status => 201
    
  end

  def checkout
    presence = current_user.presences.active.find_by_venue_id(params[:id])
    status = if presence.nil?
      404
    else
      presence.finish!
      201
    end

    render :text => '', :status => status    
  end

end
