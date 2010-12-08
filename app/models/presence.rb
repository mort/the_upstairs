class Presence < ActiveRecord::Base
 
  belongs_to :user
  belongs_to :venue
  
  named_scope :active, :conditions => 'finished_at IS NULL'
  named_scope :finished, :conditions => 'finished_at IS NOT NULL'
  
  before_create :cancel_prior!
  after_create :join_commchannel
  before_destroy :leave_commchannel
  
  def validate
    errors.add_to_base 'Not in tile' unless user.in_tile?(venue.tile.id)
    errors.add_to_base 'Not in venue' unless user.in_venue?(venue)    
  end
  
  def destroy
    finish!
  end
  
  private
  
  def join_commchannel
    user.join_commchannel(venue.commchannel)
  end
  
  def leave_commchannel
    user.leave_commchannel(venue.commchannel)
  end
  
  def cancel_prior!
    ActiveRecord::Base.connection.execute("UPDATE presences SET finished_at = '#{Time.now.to_s(:db)}' WHERE user_id = #{user.id} AND finished_at IS NULL")
  end

  def finish!
    self.update_attribute(:finished_at, Time.now)
  end

end

# == Schema Information
#
# Table name: presences
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  venue_id    :integer(4)
#  finished_at :datetime
#  created_at  :datetime
#  updated_at  :datetime
#

