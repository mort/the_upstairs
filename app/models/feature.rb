class Feature < ActiveRecord::Base

  belongs_to :tile
  
  def geohash
    GeoHash.encode(lat,lon)
  end
  
  def csquare
    CSquare.new(self.lat,self.lon).code
  end

  def to_json
    {:id => p.id, :lon => p.lon, :lat => p.lat, :title => p.title, :url => p.url, :geohash => p.geohash, :link => journey_picture_url(current_user.ongoing_journey, p)}
  end
  

end

# == Schema Information
#
# Table name: features
#
#  id         :integer(4)      not null, primary key
#  tile_id    :integer(4)
#  service    :string(255)
#  type       :string(255)
#  title      :string(255)
#  lat        :float
#  lon        :float
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  cluster_id :integer(4)
#

