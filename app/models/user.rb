class User < ActiveRecord::Base
  has_many :journeys, :order => 'created_at DESC'
  has_one  :journey, :conditions => "status = #{Journey::STATUSES[:ongoing]}", :order => 'created_at DESC'
  
  has_many :pings
    
  has_many :presences
  has_one  :current_presence, :class_name => 'Presence', :conditions => 'presences.finished_at IS NULL', :order => 'created_at DESC'
  
  has_many :client_applications
  has_many :tokens, :class_name => "OauthToken", :order => "authorized_at desc", :include => [:client_application]
  
  has_many :feed_items, :order => 'created_at DESC'
  
  has_many :engagements
    
  acts_as_authentic do |c|
    c.require_password_confirmation = false
  end
  
  def ongoing_journey
    self.journey ||= self.journeys.create(:status => Journey::STATUSES[:ongoing])
  end
  
  def current_tile
    ongoing_journey.current_tile
  end

  def current_venue
   current_presence.venue
  end
  
  def currently_in_venue?
    !current_presence.nil?
  end
  
  def in_tile?(tile_id)
    current_tile.id == tile_id.to_i
  end
  
  def in_journey?(journey_id)
    ongoing_journey.id == journey_id.to_i
  end
  
  def in_venue?(venue_id)
    current_presence.venue.id == venue_id.to_i
  end

  def in_same_tile?(user_b)
    current_tile == user_b.current_tile
  end
  
  def in_same_venue?(user_b)
    current_venue == user_b.current_venue
  end

  def admin?
    true
  end

end
