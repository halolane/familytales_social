class SessionsController < ApplicationController

	def new

	end

	def create
    @user = User.from_omniauth(env["omniauth.auth"])
    # if @user && @user.authenticate(params[:session][:password])
    if @user 
      sign_in @user
      flash[:success] = "Welcome back to FamilyTales."
      redirect_to root_url
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def failure
  end

	def destroy
		sign_out
		redirect_to root_url
	end
end
