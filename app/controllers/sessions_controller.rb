class SessionsController < ApplicationController

	def new

	end

	def create
    @user = User.from_omniauth(env["omniauth.auth"])
    # if @user && @user.authenticate(params[:session][:password])
    if @user 
      sign_in @user
      if @user.email.nil?
        redirect_to email_user_path(@user)
      else
        flash[:success] = "Welcome back to FamilyTales."
        redirect_to root_url
      end
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
