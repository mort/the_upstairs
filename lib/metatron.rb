class Metatron

  def self.tell_all_travelers(ubication,msg,msg_type)
    return unless ubication.respond_to?(:current_journeys)
    self.do_mass_journey_notifications(ubication.current_journeys,msg,msg_type)
  end
  
  def self.do_mass_journey_notifications(journeys,msg,msg_type)
    journeys.map { |j| self.do_journey_notification(j,msg,msg_type) }
  end
  
  def self.do_journey_notification(journey,msg,msg_type)
    user = journey.user
    position = journey.current_position
    presence = user.current_presence
    
    journey.feed_items.create(:body => msg, :feed_item_type => msg_type, :user => user,  :position => position, :presence => presence)
  end


  def self.reloadable?
    false
  end

end