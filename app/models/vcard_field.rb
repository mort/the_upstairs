class VcardField < ActiveRecord::Base
  belongs_to :user

  VALID_FIELDS = %(email tel)
  
  validates_inclusion_of :name, :in => VALID_FIELDS
  validates_presence_of :name, :value
  
end

# == Schema Information
#
# Table name: vcard_fields
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  name       :string(255)
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

