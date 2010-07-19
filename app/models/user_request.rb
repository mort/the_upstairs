class UserRequest < ActiveRecord::Base

  def validate
    errors.add("Not here") and return unless user.in_same_tile_that?(requester)
    errors.add("Not here") and return unless !user.currently_in_venue? || user.in_same_venue_that?(requester)  
    errors.add("Unknown request type") and return unless %(Handshake Engagement).include?(type)
    errors.add("Not engaged") and return unless user.engaged_with?(requester) || !requires_engagement(type)
  end
  
  def requires_engagement(type)
    type != 'Engagement'
  end

end
