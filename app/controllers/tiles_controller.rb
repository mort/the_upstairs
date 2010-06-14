class TilesController < ApplicationController

  before_filter :oauth_required, :only => [:show, :map]
  
  def index
    conditions = {}
    conditions.merge!({:woeid => params[:woeid]}) if params[:woeid]
    @tiles = Tile.all(:conditions => conditions, :order => 'lat DESC, lon ASC')
  end
  
  def show
    @tile = Tile.find(params[:id])
    verify_in_tile(@tile)
    
    respond_to do |format|
      format.json
    end
  end
  
  
  def map
    @tile = Tile.find(params[:id], :include => :features)
    verify_in_tile(@tile)
    
    respond_to do |format|
      format.json
    end
  end
  
  def feed
    @tile = Tile.find(params[:id])
    verify_in_tile(@tile)
    
    @messages = @tile.public_messages
    
    respond_to do |format|
      format.atom
    end
  end
  
  
end
