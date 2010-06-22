class Position < ActiveRecord::Base

  belongs_to :tile
  belongs_to :ping
  belongs_to :journey
  
  before_create :expire_prior!
  
  named_scope :active, :conditions => 'expired_at IS NULL'
  named_scope :expired, :conditions => 'expired_at IS NOT NULL'
  
  private
  
  def expire_prior!    
    ActiveRecord::Base.connection.execute("UPDATE positions SET expired_at = '#{Time.now.to_s(:db)}' WHERE journey_id = #{journey.id} AND expired_at IS NULL")
  end

end
