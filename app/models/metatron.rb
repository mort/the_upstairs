class Metatron

  def self.tell_to_all_travelers_on_tile(tile,msg,msg_type)
    self.do_mass_journey_notification(tile.current_journeys,msg,msg_type)
  end
  
  def self.tell_to_all_travelers_in_venue(venue,msg,msg_type)
    self.do_mass_journey_notifications(venue.current_journeys,msg,msg_type)
  end
  
  def self.do_mass_journey_notifications(journeys, msg, msg_type)
    journeys.map { |j| self.do_journey_notification(j,msg,msg_type) }
  end
  
  def self.do_journey_notification(journey,msg,msg_type)
    user = journey.user
    #position = user.current_position
    presence = user.current_presence
    
    journey.feed_items.create(:body => msg, :feed_item_type => msg_type, :user => user,  :presence => presence)
  end


end