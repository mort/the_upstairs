class Commchannel < ActiveRecord::Base
  
  def key
    ['up','commchannels', self.id].join(':')
  end
  
  def members_key
    [key,'members'].join(':')
  end

end
