class UserRequest < ActiveRecord::Base

  def validate
    errors.add("Not in same tile") and return unless user.in_same_tile_with?(requester) 
    errors.add("Unknown request type") and return unless %(Handshake Engagement).include?(type)
    errors.add("Not engaged") and return unless user.engaged_with?(requester) || !requires_engagement(type)
  end
  
  def requires_engagement(type)
    type != 'Engagement'
  end

end
