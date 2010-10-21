class FeedItem < ActiveRecord::Base
  belongs_to :journey
  belongs_to :user
  belongs_to :position
  belongs_to :presence
  
  named_scope :unread, :conditions => 'read_at IS NULL'
  named_scope :read, :conditions => 'read_at IS NOT NULL'
end

# == Schema Information
#
# Table name: feed_items
#
#  id             :integer(4)      not null, primary key
#  journey_id     :integer(4)
#  position_id    :integer(4)
#  presence_id    :integer(4)
#  title          :string(255)
#  feed_item_type :string(255)     default(""), not null
#  body           :text            default(""), not null
#  scope          :string(255)
#  actionable     :boolean(1)      default(FALSE)
#  read_at        :datetime
#  created_at     :datetime
#  updated_at     :datetime
#  actions        :text
#  user_id        :integer(4)
#

