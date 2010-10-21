class Venue < Feature
  
  has_many :presences
  has_many :current_presences, :class_name => 'Presence', :conditions => 'finished_at IS NULL'

  validates_uniqueness_of :url
  
  def current_journeys
    current_presences.map{|p| p.user.ongoing_journey }
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

