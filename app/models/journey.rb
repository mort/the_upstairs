class Journey < ActiveRecord::Base

  STATUSES = {:ongoing => 1, :finished => 0}
  
  belongs_to :user
  
  has_many :feed_items, :order => 'created_at DESC', :conditions => "scope IS NULL OR scope = 'journey'"
  
  has_many :positions  
  has_one :current_position, :class_name => 'Position', :conditions => 'expired_at IS NULL', :order => 'created_at DESC'
  
  has_many :tiles, :through => :positions
  has_one  :current_tile,  :through => :positions, :source => :tile, :conditions => 'positions.expired_at IS NULL', :order => 'created_at DESC'
    
  named_scope :ongoing, :conditions => {:status => STATUSES[:ongoing]}
  
  delegate :stats, :to => :user, :prefix => true

  def elapsed_time
    Time.now - self.created_at
  end
  
  
  def stats
    stats = {
      :ongoing => (status == STATUSES[:ongoing]),
      :elapsed_time => elapsed_time,
      :user_id => user_id,
      :position => current_position,
      :tile => current_tile,
      :in_venue => user.currently_in_venue?      
    }
    
    stats.merge(:venue => user.current_venue) if user.currently_in_venue?

    stats
  end
  
end

# == Schema Information
#
# Table name: journeys
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  token      :string(255)
#  status     :integer(2)
#  created_at :datetime
#  updated_at :datetime
#

