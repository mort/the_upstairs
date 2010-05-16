class Position < ActiveRecord::Base
  belongs_to :tile
  belongs_to :ping
  belongs_to :user
end
