class Engagement < ActiveRecord::Base
  STATUSES = {:finished => 0, :active => 1}

  belongs_to :user
  belongs_to :requester, :class_name => 'User'

  def self.proceed(request)
    user = request.user
    user.engagements.create(:request => request.id, :requester => request.requester)
  end

  def finish!
    update_attributes(:status => STATUSES[:finished], :finished_at => Time.now)
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

