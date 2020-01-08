class UsersController < ApplicationController
    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.create(user_params)

        if @user.save
            session[:session_token] = @user.reset_session_token!
            flash[:success] = 'Welcome to Music App! Account created successfully'
            redirect_to user_url
        else
            render :new, status: 422
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password)
    end
end