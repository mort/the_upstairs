class ActivityStreamObserver < ActiveRecord::Observer
  
  def after_create(act)
    n = act.actor_name
    
    case act.activity
      when 'movement' 
        t = Tile.find(act.object_id)
        Metatron.tell_to_all_travelers_on_tile(t,"#{n} enters the tile")
      when 'presence' 
        f = Feature.find(act.object_id)
        t = f.tile
        v = (act.verb == 'enters_venue') ? "enters" : 'leaves'
        Metatron.tell_to_all_travelers_in_venue(f,"#{n} #{v} venue #{f.title}")
    end
    
    
  end
end
