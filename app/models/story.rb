class Story < ActiveRecord::Base
  attr_accessible :body, :subtitle, :title, :user_id, :published, :lesson, :characters

  belongs_to :user
  has_many :storyphotos, dependent: :destroy
  has_many :favorites, dependent: :destroy

  default_scope order: 'stories.updated_at DESC'

  def favcount
  	favorites.count
  end
end
