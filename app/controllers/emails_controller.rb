class EmailsController < ApplicationController

	def create
    @email = Email.new(:email => params[:email][:email], :user_id => current_user.id, :notify => true, :digest => true)

    respond_to do |format|
      if @email.save
        format.html { redirect_to root_url, notice: 'Email was successfully created.' }
        format.json { render json: @email, status: :created, location: @email }
      else
        format.html { rredirect_to email_user_url(current_user) }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end

	def update
    @email = Email.find(params[:id])

    respond_to do |format|
      if @email.update_attributes(params[:email])
        format.html { redirect_to root_url, notice: 'Email was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to email_user_url(current_user) }
        format.json { render json: @email.errors, status: :unprocessable_entity }
      end
    end
  end
end
