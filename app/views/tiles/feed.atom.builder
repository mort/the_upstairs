atom_feed do |feed|
  feed.title("Tile messages for tile #{@tile.id}")
  feed.updated(@messages.first.updated_at)
 
  for message in @messages
    next if message.updated_at.blank?
    feed.entry([message], :url => '') do |entry|
      entry.content(message.body, :type => 'text')
      entry.updated(message.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) # needed to work with Google Reader.
    end
  end
end