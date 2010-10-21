class UserRequest < ActiveRecord::Base

  STATUSES = {:pending => 0, :accepted => 1, :declined => 2}
  
  STATUSES.each do |status, value|
    self.send(:named_scope, status, :conditions => "status = #{value}")
  end
  
  TYPES = %w(Handshake Engagement)
  
  belongs_to :user
  belongs_to :requester, :class_name => 'User', :foreign_key => 'requester_id'
  
  after_create :notify_user

  def validate
    errors.add("Not in same tile") and return unless user.in_same_tile_that?(requester)
    errors.add("Not in same venue") and return unless user.in_same_venue_that?(requester)  
    errors.add("Unknown request type") and return unless TYPES.include?(type)
    errors.add("Not engaged") and return if requires_engagement?(type) && !user.engaged_with?(requester)
  end
  
  def requires_engagement?(type)
    type != 'Engagement'
  end
  

  def accept!
    update_attributes(:status => STATUSES[:accepted], :accepted_at => Time.now)
    # a little metaprogramming to invoke the proceed callback on the appropiate class
    # Engagement.proceed, Handshake.proceed, etc.
    klass_callback(:proceed)
  end

  def decline!
    update_attributes(:status => STATUSES[:declined], :declined_at => Time.now)
    # a little metaprogramming to invoke the cancel callback on the appropiate class
    # Engagement.cancel, Handshake.cancel, etc.
    klass_callback(:cancel)
  end
  
  private
  
  def klass_callback(callback)
    klass = type.camelize.constantize
    klass.send(callback, self) if klass.respond_to?(callback)
  end
  
  def notify_user
    user.notify("#{requester.login} wants to #{type.downcase}", "New user request", {:actionable => true, :actions => actions})
  end
  
  def actions
    actions = {}
    actions[:accept] = 'foo'
    actions[:decline] = 'foo'

    actions.to_json
  end
  

end

# == Schema Information
#
# Table name: user_requests
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  requester_id :integer(4)
#  request_type :string(255)     default(""), not null
#  status       :integer(4)      default(0), not null
#  accepted_at  :datetime
#  declined_at  :datetime
#  created_at   :datetime
#  updated_at   :datetime
#

