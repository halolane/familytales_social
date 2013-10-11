class Favorite < ActiveRecord::Base
  attr_accessible :story_id, :user_id

  belongs_to :user
  belongs_to :story

  validates :user_id, presence: true 
  validates :story_id, presence: true
end
