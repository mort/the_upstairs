class Tile < ActiveRecord::Base
  
  #validates_uniqueness_of :geohash, :csquare_code, :lat, :lon
    
  def self.make(lat_sw = 0.0, lon_sw = 0.0, lat_ne = 90.0, lon_ne = 180.0, woe_id = nil, step = 0.01)
    
    lat = lat_sw
    lon = lon_sw
        
      while lat < lat_ne
  
        lat = ('%0.2f' % lat).to_f
      	      	
      	while lon < lon_ne
      	  
      	  lon = ('%0.2f' % lon).to_f
                	  
      	  csquare = CSquare.new(lat,lon)
      	  geohash = GeoHash.encode(lat,lon)
          
      		begin
      		  tile = self.create(:lat => lat, :lon => lon, :csquare_code => csquare.code, :geohash => geohash, :woe_id => woe_id)
    	    rescue ActiveRecord::StatementInvalid

  	      end
      	  lon = lon + step

      	end

        lon = lon_sw
      	lat = lat + step

      end

  end
  
  def self.estimate_x(lon_sw = 0.0, lon_ne = 180.0, step = 0.01)
    ((lon_ne-(lon_sw))/step).ceil.to_i 
  end
  
  def self.estimate_y(lat_sw = 0.0, lat_ne = 90.0,  step = 0.01)
    ((lat_ne-lat_sw)/step).ceil.to_i
  end
  
  def self.estimate(lat_sw = 0.0, lon_sw = 0.0, lat_ne = 90.0, lon_ne = 180.0, step = 0.01)
    self.estimate_x(lon_sw,lon_ne,step)*self.estimate_y(lat_sw,lat_ne,step)
  end


  def n
    Tile.find(:first, :conditions => ['lat > ? AND id <> ?', self.lat, self.id], :order => 'lat ASC')
  end
  
  def s
    Tile.find(:first, :conditions => ['lat < ? AND id <> ?', self.lat, self.id], :order => 'lat DESC')
  end
  
  def e
    Tile.find(:first, :conditions => ['lon > ? AND id <> ?', self.lon, self.id], :order => 'lon ASC')
  end
  
  def w
    Tile.find(:first, :conditions => ['lon < ? AND id <> ?', self.lon, self.id], :order => 'lon ASC')
  end
  
end