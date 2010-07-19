class Engagement < ActiveRecord::Base

  def self.proceed(request)
    user = request.user
    user.engagements.create(:request => request.id, :requester => request.requester)
  end

end
