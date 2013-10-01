class Storyphoto < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :story_id, :photo, :featured
  belongs_to :story
  before_destroy :destroy_image

  has_attached_file :photo, :source_file_options =>  {:all => '-auto-orient'}, :styles => Proc.new { |photo| photo.instance.styles }

  validates_attachment :photo,
  :content_type => { :content_type => /image/ },
  :size => { :in => 0..5.megabytes }
  
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
    photo.reprocess!(dynamic_style_format_symbol) unless photo.exists?(dynamic_style_format_symbol)
    photo.url(dynamic_style_format_symbol)
  end

  private
	  def destroy_image
	    self.photo.clear
	    self.photo.destroy
	  end
end
