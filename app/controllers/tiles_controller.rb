class TilesController < ApplicationController

  before_filter :oauth_required, :only => [:show, :map]
  before_filter :validate_request, :except => :index
  
  def index
    conditions = {}
    conditions.merge!({:woeid => params[:woeid]}) if params[:woeid]
    @tiles = Tile.all(:conditions => conditions, :order => 'lat DESC, lon ASC')
  end
  
  def show
    @tile = Tile.find(params[:id])

    respond_to do |format|
      format.json
    end
  end
  
  
  def map
    @tile = Tile.find(params[:id], :include => :features)
    
    respond_to do |format|
      format.json
    end
  end
  
  def feed
    @tile = Tile.find(params[:id])
    
    @messages = @tile.public_messages
    
    respond_to do |format|
      format.atom
    end
  end
  
  private
  
  def validate_request
    render :text => '', :status => 404 unless (current_user.in_journey?(params[:journey_id]) && current_user.in_tile?(params[:id]))
  end
end
