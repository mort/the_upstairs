class Journey < ActiveRecord::Base

  STATUSES = {:ongoing => 1, :finished => 0}
  
  belongs_to :user
  
  has_many :feed_items, :order => 'created_at DESC', :conditions => "scope IS NULL OR scope = 'journey'"
  
  has_many :positions  
  has_one :current_position, :class_name => 'Position', :conditions => 'expired_at IS NULL', :order => 'created_at DESC'
  
  has_many :tiles, :through => :positions
  has_one  :current_tile,  :through => :positions, :conditions => 'positions.expired_at IS NULL', :order => 'created_at DESC'
  
  delegate [:current_tile, :current_position], :to => :user
  
  named_scope :ongoing, :conditions => {:status => STATUSES[:ongoing]}

  def elapsed_time
    Time.now - self.created_at
  end
  
end
