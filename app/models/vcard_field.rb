class VcardField < ActiveRecord::Base
  belongs_to :user

  VALID_FIELDS = %(email tel)
  
  validates_inclusion_of :name, :in => VALID_FIELDS
  validates_presence_of :name, :value
  
end
