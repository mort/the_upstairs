class FeedItemsController < ApplicationController
  before_filter :oauth_required
  
  def index
    @journey = current_user.ongoing_journey
    @items = @journey.feed_items.unread
    
    respond_to do |format|
      format.atom
    end
  
  end
  
end
