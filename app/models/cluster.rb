class Cluster < ActiveRecord::Base
  validates_uniqueness_of :lat, :scope => [:lon, :cluster_type]
  
  belongs_to :tile
  has_many :pictures, :dependent => :nullify
  has_many :venues, :dependent => :nullify
  
end
