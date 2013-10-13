class StoriesController < ApplicationController
  before_filter :signed_in_user, only: [:destroy, :edit, :create, :favorite, :unfavorite]
  before_filter :correct_user_or_published, only: :show
  before_filter :correct_user,   only: :edit
  # GET /stories
  # GET /stories.json
  def index
    @stories = Story.where(published: true).paginate(page: params[:page], :per_page => 6)
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
    @popularstories = Story.where(published: true).
                          select("stories.id, stories.title, stories.user_id, stories.body, count(favorites.id) AS fav_count"). 
                          joins(:favorites).
                          group("stories.id").
                          order("fav_count DESC").
                          limit(6)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @story }
    end
  end

  # GET /stories/new
  # GET /stories/new.json
  def new
    @story =  current_user.stories.build()
    @story.title = ""
    @story.body = ""
    @story.lesson = ""
    @story.characters = ""
    @story.published = false
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
      if not @story.storyphotos.where(:featured => true).blank? 
        @featuredphotos = @story.storyphotos.where(:featured => true)
        @featuredphotos.each do |fphoto|
          fphoto.photo.destroy
          fphoto.destroy
        end
      end

      @photo = @story.storyphotos.build(:photo => params[:storyphoto][:photo])
      @photo.toggle(:featured)
      @photosaved = true
      if ! @photo.save
        @photosaved = false
      end
    end

    respond_to do |format|
      if @story.update_attributes(params[:story])
        format.html { redirect_to edit_story_path(@story), notice: 'Story was successfully updated.' }
        format.js
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

  def favorite 
    @story = Story.find(params[:id])
    @favstory = current_user.favstory!(@story)

    respond_to do | format |   
      if @favstory.save 
        format.html { redirect_to @story } 
        format.js 
      else
        format.html { redirect_to @story, notice: 'Unable to like story.' } 
      end
    end
  end

  def unfavorite 
    @story = Story.find(params[:id])
    
    respond_to do | format |   
      if current_user.unfavstory!(@story)
        format.html { redirect_to @story } 
        format.js 
      else
        format.html { redirect_to @story, notice: 'Unable to unfav story.' } 
      end
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
