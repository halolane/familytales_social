class EmailsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :update]

	def create
    @email = Email.new(:email => params[:email][:email], :user_id => current_user.id, :notify => true, :digest => true)

    respond_to do |format|
      if @email.save
        mailchimp_save
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

  private 
    def mailchimp_save
      mailchimp_api_key = "47a9f77ac40a4f62fe0baf3f4965d205-us7"
      mailchimp_list_id = "6abaad37e4"
      first_name = current_user.name.split(' ').first
      last_name = current_user.name.split(' ').last
      g = Gibbon::API.new(mailchimp_api_key)
      g.throws_exceptions = false

      g.lists.subscribe({ :id => mailchimp_list_id, 
                          :email => {:email => @email.email}, 
                          :double_optin => false, 
                          :send_welcome => false, 
                          :merge_vars => {:FNAME => first_name, 
                                          :LNAME => last_name}
                        })

    end
end
