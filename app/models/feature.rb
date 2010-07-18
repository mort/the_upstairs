class Feature < ActiveRecord::Base

  belongs_to :tile
  
  def geohash
    GeoHash.encode(lat,lon)
  end
  
  def csquare
    CSquare.new(self.lat,self.lon).code
  end

end
