# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :current_user
  include LogActivityStreams
  
  #protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  

   private
     def current_user_session
       return @current_user_session if defined?(@current_user_session)
       @current_user_session = UserSession.find
     end

     def current_user
       return @current_user if defined?(@current_user)
       @current_user = current_user_session && current_user_session.user
     end
     
     def login_required
       require_user
     end

     def authorized?
      true
     end

     def require_user
       unless current_user
         store_location
         flash[:notice] = "You must be logged in to access this page"
         redirect_to new_user_session_url
         return false
       end
     end

     def require_no_user
       if current_user
         store_location
         flash[:notice] = "You must be logged out to access this page"
         redirect_to account_url
         return false
       end
     end

     def store_location
       session[:return_to] = request.request_uri
     end

     def redirect_back_or_default(default)
       redirect_to(session[:return_to] || default)
       session[:return_to] = nil
     end

     def when_in(e, &block)
       self.send("when_in_#{e.class.to_s.downcase}".to_sym, e, &block) 
     end

     def when_in_tile(tile, &block)      
       condition = (current_user.in_journey?(params[:journey_id]) && current_user.in_tile?(tile.id)) 
       stop_or_go(condition, {}, &block) 
     end
     
     def when_in_venue(venue, &block)
       condition = (current_user.current_presence.venue == venue)
       stop_or_go(condition, {}, &block) 
     end
     
     def stop_or_go(condition, options = {}, &block)
       opt = {:text => '', :status => 404}
       opt.update(options) unless options.blank?
       condition ? block.call : render(opt) and return
     end

end
