class Scene < ActiveRecord::Base
  belongs_to :tile
  
  serialize :content, Hash
  
end
