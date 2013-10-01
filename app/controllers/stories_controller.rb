class StoriesController < ApplicationController
  before_filter :signed_in_user, only: [:destroy, :edit, :create]
  before_filter :correct_user_or_published, only: :show
  before_filter :correct_user,   only: :edit
  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.where(published: true)
    @user = User.new
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.json
  def show
    @story = Story.find(params[:id])
    @user = User.new
    @storyauthor = @story.user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.json
  def new
    @story =  current_user.stories.build()
    @story.save

    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/1/edit
  def edit
    @story = Story.find(params[:id])
  end

  # POST /stories
  # POST /stories.json
  def create
    @story =  current_user.stories.build(params[:story])
    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: 'Story was successfully created.' }
        format.json { render json: @story, status: :created, location: @story }
      else
        format.html { render action: "new" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stories/1
  # PUT /stories/1.json
  def update
    @story = Story.find(params[:id])
    if @story.title.nil?
      @story.title = ""
    end

    if not params[:storyphoto].nil? and not params[:storyphoto][:photo].nil?
      @photo = @story.storyphotos.build(:photo => params[:storyphoto][:photo])
      @photo.toggle(:featured)
      if ! @photo.save
        photosaved = false
      end
    end

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to @story, notice: 'Story was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.json
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to stories_url }
      format.json { head :no_content }
    end
  end

  def publish
    @story = Story.find(params[:id])
    @story.published = true
    if @story.title.nil?
      @story.title = ""
    end
    @story.save
    respond_to do |format|
      format.html { redirect_to stories_url }
      format.json { head :no_content }
    end
  end

  private

    def correct_user
      @story = Story.find(params[:id])
      @user = User.find(@story.user_id)
      redirect_to(root_path) unless current_user?(@user)
    end

    def correct_user_or_published
      @story = Story.find(params[:id])
      @user = User.find(@story.user_id)
      redirect_to(root_path) unless ( current_user?(@user) or @story.published )
    end
end
