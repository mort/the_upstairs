class FeaturesController < ApplicationController
  before_filter :validate_request
  
  def show
    render :text => @feature.to_json
  end
  
  
  
  private
  
  def validate_request
    @feature = begin
      Feature.find(params[:id])
    rescue ActiveRecord::RecordNotFound 
      nil
    end
    render :text => '', :status => 404 unless (@feature.nil? || (current_user.in_journey?(params[:journey_id]) && current_user.in_tile?(@feature.tile.id)))
  end
  
end
