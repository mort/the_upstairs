class UserRequestsController < ApplicationController
  before_filter :oauth_required
  
  def create
    requester = current_user
    user = User.find(params[:user_id])
    
    user_request = user.user_requests.create(:requester => requester, :type => param[:type])
  
    unless user_request.new_record?
      render user_request.to_json, :status => 201
    else
      render user_request.errors.to_json, :status => 400  
    end

  
  end

end
