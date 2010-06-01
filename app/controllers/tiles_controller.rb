class TilesController < ApplicationController
  before_filter :validate_request, :except => :index
  before_filter :require_user, :only => :index
  
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
  
  private
  
  def validate_request
    render :text => '', :status => 404 unless (current_user.in_journey?(params[:journey_id]) && current_user.in_tile?(params[:id]))
  end
end
