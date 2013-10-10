class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :signed_in_user, only: [:index, :destroy, :email]

  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @publishedstories = @user.stories.where(:published => true)
    @draftstories = @user.stories.where('published != ?', true)
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @email = @user.email
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    @email = @user.email
    respond_to do |format|
      if @user.update_attributes(params[:user]) 
        if @email.nil? 
          @email = Email.new(:email => params[:email][:email], :user_id => @user.id, :notify => true, :digest => true)
          if @email.save
            mailchimp_save
          end
        else
          @email.update_attributes(params[:email])
        end
        
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def email

    if current_user.email.nil?
      @email = Email.new
    else
      @email = current_user.email
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private 
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def mailchimp_save
      mailchimp_api_key = "9d733223f7c559a0b6f133d7c604ca86-us7"
      mailchimp_list_id = "6abaad37e4"
      @email = current_user.email
      first_name = @user.name.split(' ').first
      last_name = @user.name.split(' ').last
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
