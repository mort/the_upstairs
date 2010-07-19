class Handshake < ActiveRecord::Base

  def self.proceed(request)
    user = request.user
    user.handshakes.create(:request => request.id, :requester => request.requester)
  end
  
end
