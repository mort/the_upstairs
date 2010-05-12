class TilesController < ApplicationController
  
  def index
    conditions = {}
    conditions.merge!({:woeid => params[:woeid]}) if params[:woeid]
    @tiles = Tile.all(:conditions => conditions, :order => 'lat DESC, lon ASC')
  end
  
  def show
    @tile = Tile.find(params[:id])
  end
end
