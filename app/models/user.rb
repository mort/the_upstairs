class User < ActiveRecord::Base
  has_many :journeys, :order => 'created_at DESC'
  has_one  :journey, :conditions => "status = #{Journey::STATUSES[:ongoing]}", :order => 'created_at DESC'
  
  has_many :pings
    
  has_many :presences
  has_one  :current_presence, :class_name => 'Presence', :conditions => 'presences.finished_at IS NULL', :order => 'created_at DESC'
  
  has_many :client_applications
  has_many :tokens, :class_name => "OauthToken", :order => "authorized_at desc", :include => [:client_application]
  
  has_many :feed_items, :order => 'created_at DESC'
  
  has_many :user_requests
  has_many :engagements
  
  has_many :vcard_fields
  
  has_many :collected_vcards
  has_many :granted_vcards, :class_name => 'CollectedVcard', :foreign_key => 'vcard_owner'
    
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

  def in_same_tile_that?(user_b)
    current_tile == user_b.current_tile
  end
  
  def in_same_venue_that?(user_b)
    self.currently_in_venue? && user_b.currently_in_venue? && (self.current_venue == user_b.current_venue)
  end
  
  def notify(msg, msg_type, options = {})
    journey = ongoing_journey
    position = journey.current_position
    presence = current_presence
    
    o = {:body => msg, 
         :feed_item_type => msg_type, 
         :journey => journey,  
         :position => position, 
         :presence => presence
         }.merge(options)    
    
    feed_items.create(o)
  end
  
  def admin?
    true
  end
  
  def engaged_with?(u)
    e = Engagement.first(:conditions => ["((user_id = ? AND requester_id = ?) OR (user_id = ? AND requester_id = ?)) AND finished_at IS NOT NULL", self.id, u.id, u.id, self.id], :order => 'created_at DESC')
    !e.nil?
  end
  
  def give_vcard_to(recipient)
    require_engagement_with(recipient)
    recipient.collected_vcards.create(:vcard_owner_id => self.id)
  end
  
  def exchange_vcards_with(recipient)
    require_engagement_with(recipient)
    User.transaction do 
      give_vcard_to(recipient)
      collected_vcards.create(:vcard_owner_id => recipient.id)
    end
  end
  
  def add_vcard_field(k,v)
    vcard_fields.create(:name => k, :value => v)
  end
  
  private
  
  def require_engagement_with(u)
    raise Exceptions::NotEngaged unless self.engaged_with?(u)
  end

end



