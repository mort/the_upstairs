class Scene < ActiveRecord::Base
  require 'digest/md5'
  belongs_to :tile
  
  serialize :content, Hash

  before_validation_on_create :set_checksum
  
  #validates_uniqueness_of :checksum
  
  def self.extract_all_features
    self.all.each do |scene|
      scene.extract_features
    end
  end
  
  def extract_features
    [:flickr,:oos].each do |service|
      if content[:results].has_key?(service)
        results = content[:results][service][:search][:results]
        results.each do |r|
          type = (service == :flickr) ? 'picture' : 'venue'
          f = self.tile.features.build(r.merge!(:service => service.to_s))
          f.type = type
          f.save
        end
      end
    end
  end
  
  private
  
  def set_checksum
    self.checksum = Digest::MD5.hexdigest(content.to_json)
  end
end
