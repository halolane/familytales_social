class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :username, :use => :slugged, :sequence_separator => ''
  attr_accessible :name, :password, :password_confirmation, :bio, :avatar, :slug, :username, :tweet_avatar, :remember_token
  has_secure_password


  validates :name, presence: true, length: { maximum: 50 }

  has_many :stories, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one :email, dependent: :destroy

  has_attached_file :avatar, :source_file_options =>  {:all => '-auto-orient'}, :styles => Proc.new { |photo| photo.instance.styles }

  validates_attachment :avatar,
  :content_type => { :content_type => /image/ },
  :size => { :in => 0..5.megabytes }

  def self.from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
    user.oauth_token = auth["credentials"]["token"]
    user.oauth_secret = auth["credentials"]["secret"]
    user.save!
    user
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.username = auth["info"]["nickname"]
      user.bio = auth["info"]["description"]
      user.tweet_avatar = auth['info']['image'].sub("_normal", "")    
      user.password = auth["credentials"]["secret"]
      user.password_confirmation = auth["credentials"]["secret"]

    end
  end
  
  def twitter
    if provider == "twitter"
      @twitter ||= Twitter::Client.new(oauth_token: oauth_token, oauth_token_secret: oauth_secret)
    end
  end

  def normalize_friendly_id(string)
    super.gsub("-", "")
  end

  def favorite?(story)
    not favorites.blank? and favorites.exists?(story_id: story.id)
  end

  def favstory!(story)
    if favorites.blank? or not favorites.exists?(story_id: story.id)
      @favorite = favorites.create!(story_id: story.id)
    end
  end

  def unfavstory!(story)
    if not favorites.blank? and favorites.exists?(story_id: story.id)
      favorites.find_by_story_id(story.id).destroy 
    end
  end

  def dynamic_style_format_symbol
    URI.escape(@dynamic_style_format).to_sym
  end

  def styles
    unless @dynamic_style_format.blank?
      { dynamic_style_format_symbol => @dynamic_style_format }
    else
      {}
    end
  end

  def dynamic_photo_url(format)
    @dynamic_style_format = format
    avatar.reprocess!(dynamic_style_format_symbol) unless avatar.exists?(dynamic_style_format_symbol)
    avatar.url(dynamic_style_format_symbol)
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

   private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
