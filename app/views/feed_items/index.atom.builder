atom_feed do |feed|
  feed.title("Notifications")
  feed.updated(@items.first.updated_at)
 
  for item in @items
    next if item.updated_at.blank?
    feed.entry([item], :url => '') do |entry|
      entry.content(item.body, :type => 'text')
      entry.updated(item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) # needed to work with Google Reader.
    end
  end
end