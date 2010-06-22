class FeedItem < ActiveRecord::Base
  belongs_to :journey
  belongs_to :user
  belongs_to :position
  belongs_to :presence
  
  named_scope :unread, :conditions => 'read_at IS NULL'
  named_scope :read, :conditions => 'read_at IS NOT NULL'
end
