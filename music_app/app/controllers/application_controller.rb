class ApplicationController < ActionController::Base

    helper_method :current_user, :logged_in?

    def logged_in?
        !!current_user
    end

    def current_user
        return nil unless session[:session_token] #if session_token is nil, if it's not nil go to next line and lookup the current user
        User.find_by(session_token: session[:session_token]) #find user
        #session_token lasts until user closes browser?
    end

    def log_in_user!(user)
        if current_user == user
            session[:session_token] = user.reset_session_token
        end
    end
end
