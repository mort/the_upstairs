class CollectedVcard < ActiveRecord::Base
  belongs_to :user
  belongs_to :owner, :class_name => 'User', :foreign_key => 'vcard_owner_id'
  
  validates_uniqueness_of :vcard_owner_id, :scope => :user_id
end

# == Schema Information
#
# Table name: collected_vcards
#
#  id             :integer(4)      not null, primary key
#  user_id        :integer(4)
#  vcard_owner_id :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#

