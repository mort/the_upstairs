class ActivityStreamObserver < ActiveRecord::Observer
  
  def after_create(act)
    n = act.actor_name
    
    case act.activity
      when 'movement' 
        t = Tile.find(act.object_id)
        t.public_messages.create(:body => "#{n} enters the tile")
      when 'presence' 
        f = Feature.find(act.object_id)
        t = f.tile
        v = (act.verb == 'enters_venue') ? "enters" : 'leaves'
    
        t.public_messages.create(:body => "#{n} #{v} venue #{f.title}")
    end
    
    
  end
end
