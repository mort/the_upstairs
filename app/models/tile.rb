class Tile < ActiveRecord::Base
  
  RESOLUTION = 0.01
  
  has_many :scenes
  has_many :features
  has_many :venues
  has_many :pictures
  has_many :positions
  
  has_many :journeys, :through => :positions
  has_many :current_journeys, :through => :positions, :source => :journey, :conditions => 'positions.expired_at IS NULL'
  
  has_many :public_messages
  
  before_create :adjust_coordinate_precision
  before_validation_on_create :set_codes
  before_validation_on_create :set_resolution

  validates_presence_of :geohash, :csquare_code, :lat, :lon, :resolution 
  validates_uniqueness_of :geohash, :csquare_code, :lat, :lon
  
  serialize :reverse_geocoding_data
  
  alias_attribute :rgd, :reverse_geocoding_data
  
  require File.join(Rails.root,'vendor','gems','gigante','lib','gigante.rb')
    
  def self.make(lat_sw = 0.0, lon_sw = 0.0, lat_ne = 90.0, lon_ne = 180.0, woeid = nil, step = 0.01)
    
    lat = lat_sw
    lon = lon_sw
        
      while lat <= lat_ne
  
        lat = ('%0.2f' % lat).to_f
      	      	
      	while lon <= lon_ne
      	  
      	  lon = ('%0.2f' % lon).to_f
                	  
      	  csquare = CSquare.new(lat,lon)
      	  geohash = GeoHash.encode(lat,lon)
          
      		begin
      		  tile = self.create(:lat => lat, :lon => lon, :csquare_code => csquare.code, :geohash => geohash, :woeid => woeid, :resolution => step)
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

  def self.safari(woeid, services = ['oos','flickr'])
    Tile.all(:conditions => ['woeid = ?',woeid]).each do |tile|
      s = tile.snapshot(services)
      tile.store_scene(s) if s[:meta][:total_results].to_i > 0
      sleep(2)
    end
  end

  def snapshot(services)
    settings = { :flickr => {:auth =>  {:api_key => '842ff12e5390937328913c5a8ee05fb8'} },
                 :yelp => {:auth => {:api_key => 'ZPJ11diDtP2Bob2AhVvhtQ'} },
                 :oos => {:auth =>  {:app_key => '7a5e65802381edf4ca98afd71eb20bd2', :app_secret => '8b7e77652569239b22a2a42c891757cf' } }  
               }
    gigante = Gigante::Search.new(settings)

    o = {}
    o[:flickr] = {:query => {:min_taken_date => '2009-12-31', :bbox => bbox.join(',') } } if services.include?('flickr')
    o[:oos] = {:query => {:bbox => bbox.join(',') } } if services.include?('oos')

    snapshot = gigante.query(self.lat,self.lon,1,services,o)
    snapshot
  end
  
  def bbox
    [self.lon,self.lat,self.lon+self.resolution,self.lat+resolution]
  end
  
  def fourcorners
    [[self.lon,self.lat],[self.lon+self.resolution,self.lat],[self.lon+resolution,self.lat+resolution],[self.lon,self.lat+resolution]]
  end
  
  def polygon
    fourcorners << fourcorners[0]
  end
  
  def tidy_and_store_scene(snapshot)
    store_scene(tidy_snapshot(snapshot))
  end
    
  def store_scene(s)
    begin
      self.scenes.create(:content => s)
      self.mark_as_explored!
    rescue ActiveRecord::StatementInvalid
    end
  end

  def mark_as_explored!
    update_attribute(:explored_at, Time.now)
  end
  
  def tidy_snapshot(snapshot)
    snapshot
  end
  
  def scene
    scenes.first
  end
  
  def flickr_results
    return nil if scene.nil?
    return nil unless scene.content[:results][:flickr][:search][:total_results].to_i > 0
    return scene.content[:results][:flickr][:search][:results]
  end

  def oos_results
    return nil if scene.nil?
    return nil unless scene.content[:results][:oos][:search][:total_results].to_i > 0
    return scene.content[:results][:oos][:search][:results]
  end

  def flickr_results?
    !flickr_results.nil?
  end

  def oos_results?
     !oos_results.nil?
   end
   
  def self.reverse_geocode
    Tile.all(:conditions => {:reverse_geocoding_data => nil}).each do |t|
      t.reverse_geocode!
    end
  end
     
  def reverse_geocode!
    res = Geokit::Geocoders::GoogleGeocoder::reverse_geocode("#{self.lat},#{self.lon}")
    update_attribute(:reverse_geocoding_data,res)
  end

  private
  
  def adjust_coordinate_precision
    self.lat = ('%0.2f' % self.lat).to_f
    self.lon = ('%0.2f' % self.lon).to_f
  end
  
  def set_codes
    self.csquare_code = CSquare.new(self.lat,self.lon).code
    self.geohash = GeoHash.encode(self.lat,self.lon)
  end
  
  def set_resolution
    self.resolution = Tile::RESOLUTION
  end
  
end