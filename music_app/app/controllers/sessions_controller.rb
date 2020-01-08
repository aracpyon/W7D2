class SessionsController < ApplicationController
    def new
        render :new
    end

    def create #when you login, you have to lookup client through crentials
        user = User.find_by_credentials(params[:email], params[:password])

        if user #user exists, already checked session token on line 7
            session[:session_token] = user.reset_session_token! #reset session_token
            flash[:success] = "Successfully logged in!"
            redirect_to user_url
        else
            render :new
        end
    end

    def destroy #logout
        current_user.reset_session_token! #as you log out reset session cookie again
        session[:session_token] = nil #if there is no sessio_token means no one logged in
        flash[:sucess] = "Logged out successfully"
        redirect_to users_url
    end
end