class Story < ActiveRecord::Base
  attr_accessible :body, :subtitle, :title, :user_id, :published, :lesson, :characters

  belongs_to :user
  has_many :storyphotos, dependent: :destroy

  default_scope order: 'stories.updated_at DESC'
end
