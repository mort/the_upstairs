class Cluster < ActiveRecord::Base
  validates_uniqueness_of :lat, :scope => [:lon, :cluster_type]
  
  belongs_to :tile
  has_many :pictures, :dependent => :nullify
  has_many :venues, :dependent => :nullify
  
end

# == Schema Information
#
# Table name: clusters
#
#  id           :integer(4)      not null, primary key
#  tile_id      :integer(4)
#  cluster_type :string(255)
#  lat          :float
#  lon          :float
#

