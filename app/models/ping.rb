class Ping < ActiveRecord::Base
  belongs_to :user
  has_one :position
  
  after_create :set_position
  
  private
  
  def set_position
    csquare = CSquare.new(('%0.2f' % self.lat).to_f,('%0.2f' % self.lon).to_f)
    tile = Tile.find_by_csquare_code(csquare.code)
    tile = Tile.create(:lat => self.lat, :lon => self.lon) if tile.nil? 
    self.position = Position.new(:user_id => self.user, :tile_id => tile.id)
  end
  
end
