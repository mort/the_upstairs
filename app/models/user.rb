class User < ActiveRecord::Base
  has_one :journey, :conditions => "status = #{Journey::STATUSES[:ongoing]}", :order => 'created_at DESC'
  has_many :journeys, :order => 'created_at DESC'
  
  has_many :pings
  has_many :tiles, :through => :positions
  
  has_many :presences
  
  acts_as_authentic 
  
  def ongoing_journey
    self.journey ||= self.journeys.create(:status => Journey::STATUSES[:ongoing])
  end
  
  def current_tile
    ongoing_journey.current_tile
  end
  
  def in_tile?(tile_id)
    current_tile.id == tile_id.to_i
  end
  
  def in_journey?(journey_id)
    ongoing_journey.id == journey_id.to_i
  end

end
