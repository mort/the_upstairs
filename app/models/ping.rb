class Ping < ActiveRecord::Base
  validates_presence_of :lat, :lon
 
  belongs_to :user
  has_one :position
  
  after_create :set_position
  
  private
  
  def set_position
    csquare = CSquare.new(('%0.2f' % self.lat).to_f,('%0.2f' % self.lon).to_f)
    tile = Tile.find_by_csquare_code(csquare.code) || Tile.create(:lat => self.lat, :lon => self.lon)
    self.position = Position.create(:ping_id => self.id, :journey_id => self.user.ongoing_journey.id, :tile_id => tile.id)
  end
  
end

# == Schema Information
#
# Table name: pings
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  lat        :float
#  lon        :float
#  created_at :datetime
#  updated_at :datetime
#

