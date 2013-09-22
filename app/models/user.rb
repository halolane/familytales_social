class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged, :sequence_separator => ''
  attr_accessible :email, :name, :password, :password_confirmation, :bio, :avatar, :slug
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }

  has_many :stories, dependent: :destroy

  has_attached_file :avatar, :source_file_options =>  {:all => '-auto-orient'}, :styles => Proc.new { |photo| photo.instance.styles }

  validates_attachment :avatar,
  :content_type => { :content_type => /image/ },
  :size => { :in => 0..5.megabytes }
  
  def normalize_friendly_id(string)
    super.gsub("-", "")
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
end
