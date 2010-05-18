class User < ActiveRecord::Base
  has_many :pings
  has_many :positions
  has_many :tiles, :through => :positions
  
  acts_as_authentic 
end
