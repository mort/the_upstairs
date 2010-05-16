class PositionsController < ApplicationController
  
  def create
    position = Position.create(params[:position])
    csquare = CSquare.new(('%0.2f' % position.lat).to_f,('%0.2f' % position.lon).to_f)
    
    tile = if Tile.find_by_csquare_code(csquare.code)
    else
      Tile.create({:lat => position.lat, :lon => position.lon, :resolution => 0.01})
    end 
    
    render :text = tile.to_json
    
    
  end

end
