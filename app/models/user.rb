class User < ActiveRecord::Base
  has_many :journeys, :order => 'created_at DESC'
  has_one  :journey, :conditions => "status = #{Journey::STATUSES[:ongoing]}", :order => 'created_at DESC'
  
  has_many :pings
    
  has_many :presences
  has_one  :current_presence, :class_name => 'Presence', :conditions => 'presences.finished_at IS NULL', :order => 'created_at DESC'
  
  has_many :client_applications
  has_many :tokens, :class_name => "OauthToken", :order => "authorized_at desc", :include => [:client_application]
  
  has_many :feed_items, :order => 'created_at DESC'
  
  has_many :user_requests
  has_many :engagements
  
  has_many :vcard_fields

  has_many :collected_vcards
  has_many :granted_vcards, :class_name => 'CollectedVcard', :foreign_key => 'vcard_owner'
  
  has_many :talked_words, :class_name => 'Word', :as => :emitter
  has_many :heard_words, :class_name => 'Word', :as => :receiver
  
  has_many :wordspace_participations, :class_name => 'WordsPace'
  has_many :wordspaces, :through => :wordspace_participations
  
    
  acts_as_authentic do |c|
    c.require_password_confirmation = false
  end
  
  include Up::Userlib
  
  def notify(msg, msg_type, options = {})
    journey = ongoing_journey
    position = journey.current_position
    presence = current_presence
    
    o = {:body => msg, 
         :feed_item_type => msg_type, 
         :journey => journey,  
         :position => position, 
         :presence => presence
         }.merge(options)    
    
    feed_items.create(o)
  end
  
  def admin?
    true
  end

  def channel_id(emitter)
    "#{self.class.to_s.downcase}:#{active_engagement_with(emitter).id}"
  end
  
  def join_commchannel(commchannel)
    Redis.sadd commchannel.members_key, self.id  
  end
  
  def leave_commchannel(commchannel)
    Redis.srem commchannel.members_key, self.id  
  end
  
  private
  
  def require_engagement_with(u)
    raise Exceptions::NotEngaged unless self.engaged_with?(u)
  end
  
  def require_presence_in_venue(v)
    raise Exceptions::NotInTheVenue unless self.in_venue?(v.id)
  end
  
  def require_presence_in_tile(t)
    raise Exceptions::NotInTheTile unless self.in_tile?(t.id)
  end

end
# == Schema Information
#
# Table name: users
#
#  id                    :integer(4)      not null, primary key
#  login                 :string(255)     not null
#  email                 :string(255)     not null
#  crypted_password      :string(255)     not null
#  password_salt         :string(255)     not null
#  persistence_token     :string(255)     not null
#  single_access_token   :string(255)     not null
#  perishable_token      :string(255)     not null
#  login_count           :integer(4)      default(0), not null
#  failed_login_count    :integer(4)      default(0), not null
#  last_request_at       :datetime
#  current_login_at      :datetime
#  last_login_at         :datetime
#  current_login_ip      :string(255)
#  last_login_ip         :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  activity_stream_token :string(255)
#

