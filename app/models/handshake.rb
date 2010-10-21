class Handshake < ActiveRecord::Base

  def self.proceed(request)
    user = request.user
    user.handshakes.create(:request => request.id, :requester => request.requester)
  end
  
end

# == Schema Information
#
# Table name: handshakes
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  requester_id :integer(4)
#  request_id   :integer(4)
#  status       :integer(4)      default(0), not null
#  broken_at    :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

