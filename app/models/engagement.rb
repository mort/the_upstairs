class Engagement < ActiveRecord::Base
  STATUSES = {:finished => 0, :active => 1}

  def self.proceed(request)
    user = request.user
    user.engagements.create(:request => request.id, :requester => request.requester)
  end

  def finish!
    update_attributes(:status => STATUSES[:finished], :finished_at => Time.now)
  end

end
