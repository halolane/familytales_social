class Story < ActiveRecord::Base
  attr_accessible :body, :subtitle, :title, :user_id, :published, :lesson, :characters

  belongs_to :user
end
