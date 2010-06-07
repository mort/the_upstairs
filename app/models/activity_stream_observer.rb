class ActivityStreamObserver < ActiveRecord::Observer
  
  def after_create(act)
    if act.activity == 'movement'
      t = Tile.find(act.object_id)
      n = act.actor_name
      t.public_messages.create(:body => "#{n} enters the tile")
    end
  end
end
