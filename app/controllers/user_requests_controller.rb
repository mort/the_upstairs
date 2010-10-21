class UserRequestsController < ApplicationController
  before_filter :oauth_required
  
  
  def create

    requester = current_user
    user = User.find(params[:user_id])
    
    user_request = user.user_requests.create(:requester => requester, :type => params[:type])
  
    opt =  user_request.new_record? ? {:text => user_request.to_json, :status => 201} : {:text => user_request.errors.to_json, :status => 400 }
    render opt
  
  end

  def do(what)
    return false unless [:accept!, :decline!].include(what)
    request = current_user.user_requests.pending.find(params[:id])
    request.send(what) unless request.nil?
    
    opt = request.nil? ? {:text => 'Not found', :status => 404} : {:text => request.to_json, :status => 200}
    render opt
  end
  
  def accept
    do(:accept!)
  end
  
  def decline
    do(:decline!)
  end
  
  
end
