class Engagement < ActiveRecord::Base
  STATUSES = {:finished => 0, :active => 1}

  belongs_to :user
  belongs_to :requester, :class_name => 'User'
  
  has_one :commchannel, :as => :context
  
  after_create :set_commchannel
  
  named_scope :active, :conditions => { :status => STATUSES[:active] }
  
  named_scope :with_user, :lambda => {|user| { :conditions => "user_id = #{user.id} OR requester_id = #{user_id}" }
   }
   

  def self.proceed(request)
    user = request.user
    user.engagements.create(:request => request.id, :requester => request.requester)
  end

  def finish!
    update_attributes(:status => STATUSES[:finished], :finished_at => Time.now)
    [user,requester].each {|u| u.leave_commchannel(channel) }
  end
  
  private
  
  def create_commchannel
    commchannel = build_commchannel
    [user,requester].each {|u| u.join_commchannel(commchannel) }
  end

end

# == Schema Information
#
# Table name: engagements
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  requester_id :integer(4)
#  request_id   :integer(4)
#  status       :integer(4)      default(0), not null
#  finished_at  :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

