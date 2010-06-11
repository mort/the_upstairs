class Presence < ActiveRecord::Base
 
  belongs_to :user
  belongs_to :venue
  
  named_scope :active, :conditions => 'finished_at IS NULL'
  named_scope :finished, :conditions => 'finished_at IS NOT NULL'
  
  before_create :cancel_prior!
  
  def finish!
    self.update_attribute(:finished_at, Time.now)
  end

  private
  
  def cancel_prior!
    ActiveRecord::Base.connection.execute("UPDATE PRESENCES SET finished_at = '#{Time.now.to_s(:db)}' WHERE user_id = #{user.id} AND finished_at IS NULL")
  end

end
