class Feature < ActiveRecord::Base
  belongs_to :tile
  
  def geohash
    GeoHash.encode(lat,lon)
  end
    
end
