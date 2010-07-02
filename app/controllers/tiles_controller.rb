class TilesController < ApplicationController

  before_filter :oauth_required, :only => [:show, :look]
  
  def index
    conditions = {}
    conditions.merge!({:woeid => params[:woeid]}) if params[:woeid]
    @tiles = Tile.all(:conditions => conditions, :order => 'lat DESC, lon ASC')
  end
  
  def show
    @tile = Tile.find(params[:id])
    
    when_in(@tile) {
      respond_to do |format|
        format.json
      end
    }
    
  end
  
  
  def look
    incl = 'features'
    incl = params[:filter] if ['venues','pictures'].include?(params[:filter])
    
    @tile = Tile.find(params[:id], :include => incl.to_sym)
  
    when_in(@tile) { 
      respond_to do |format|
        format.json
      end
    }
  
  
  end
    
  
end
