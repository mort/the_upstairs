class PresencesController < ApplicationController
  
  def create
    current_user.presences.create(:venue_id => params[:venue_id])
    render :text => '', :status => 201
  end

  def destroy
    presence = current_user.presences.active.find_by_venue_id(params[:venue_id])
    status = if presence.nil?
      404
    else
      presence.finish!
      204
    end

    render :text => '', :status => status    
  end

end
