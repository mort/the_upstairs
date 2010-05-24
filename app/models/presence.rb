class Presence < ActiveRecord::Base
  belongs_to :user
  belongs_to :venue
  
  named_scope :active, :conditions => 'finished_at IS NULL'
  named_scope :finished, :conditions => 'finished_at IS NOT NULL'
  
  def finish!
    self.update_attribute(:finished_at, Time.now)
  end

end
