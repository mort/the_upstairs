class Journey < ActiveRecord::Base
  STATUSES = {:ongoing => 1, :finished => 0}
  
  belongs_to :user
  
  has_one :position, :order => 'created_at DESC'
  has_many :positions  

  named_scope :ongoing, :conditions => {:status => STATUSES[:ongoing]}

  def elapsed_time
    Time.now - self.created_at
  end
  
  def current_tile
    position.tile
  end
  
end
