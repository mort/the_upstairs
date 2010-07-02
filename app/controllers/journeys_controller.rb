class JourneysController < ApplicationController
  before_filter :oauth_required

  def stats
    stats =  current_user.journeys.find(params[:id]).stats
    render :text => stats.to_json
  end

end
