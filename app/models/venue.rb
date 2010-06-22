class Venue < Feature
  
  has_many :presences
  has_many :current_presences, :class_name => 'Presence', :conditions => 'finished_at IS NULL'
  
  def current_journeys
    current_presences.map{|p| p.user.ongoing_journey }
  end
  
end