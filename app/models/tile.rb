class Tile < ActiveRecord::Base
  
  has_many :scenes
  
  #validates_uniqueness_of :geohash, :csquare_code, :lat, :lon
  
  require File.join(Rails.root,'vendor','gems','gigante','lib','gigante.rb')
    
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

  def go(exit = :n)
    return false unless self.responds_to?(exit)
    self.send(exit)
  end
  
  def n
    Tile.find(:first, :conditions => "lat > #{self.lat}", :order => 'lat ASC')
  end
  
  def s
   Tile.find(:first, :conditions => "lat < #{self.lat}", :order => 'lat DESC')
  end
  
  def e
    Tile.find(:first, :conditions => "lon > #{self.lon}", :order => 'lon ASC')
  end
  
  def w
    Tile.find(:first, :conditions => "lon < #{self.lon}", :order => 'lon DESC')
  end
  
  def nw
    Tile.find(:first, :conditions => "lat > #{self.lat} AND lon < #{self.lon}", :order => 'lat ASC, lon DESC')
  end
  
  def ne
    Tile.find(:first, :conditions => "lat > #{self.lat} AND lon > #{self.lon}", :order => 'lat ASC, lon ASC')
  end
  
  def sw
    Tile.find(:first, :conditions => "lat < #{self.lat} AND lon < #{self.lon}", :order => 'lat DESC, lon DESC')
  end
  
  def se
    Tile.find(:first, :conditions => "lat < #{self.lat} AND lon > #{self.lon}", :order => 'lat DESC, lon ASC')
  end

  def self.safari(woeid)
    Tile.all(:conditions => ['woeid = ?',woeid]).each do |tile|
      s = tile.snapshot
      tile.store_scene(s)
      sleep(2)
    end
  end

  def snapshot
    settings = { :flickr => {:auth =>  {:api_key => '842ff12e5390937328913c5a8ee05fb8'} },
                 :yelp => {:auth => {:api_key => 'ZPJ11diDtP2Bob2AhVvhtQ'} },
                 :oos => {:auth =>  {:app_key => '7a5e65802381edf4ca98afd71eb20bd2', :app_secret => '8b7e77652569239b22a2a42c891757cf' } }  
               }
    services = %w(flickr)           
    gigante = Gigante::Search.new(settings)
    snapshot = gigante.query(self.lat,self.lon,1,services)
    logger.info(snapshot.inspect)
    snapshot
    
  end
    
  def store_scene(snapshot)
    self.scenes.create(:content => snapshot)
  end
  

end