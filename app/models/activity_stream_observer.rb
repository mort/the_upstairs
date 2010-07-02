class ActivityStreamObserver < ActiveRecord::Observer
  
  def after_create(act)
    n = act.actor_name
    
    case act.activity
      when 'movement' 
        t = Tile.find(act.object_id)
        Metatron.tell_all_travelers(t,"#{n} enters the tile",'notice')
     # when 'presence' 
       # f = Feature.find(act.object_id)
       # t = f.tile
       # v = (act.verb == 'enters_venue') ? "enters" : 'leaves'
        #Metatron.tell_all_travelers_in_venue(f,"#{n} #{v} venue #{f.title}",'notice')
    end
    
    
  end
end
