class Story < ActiveRecord::Base
  attr_accessible :body, :subtitle, :title, :user_id

  belongs_to :user
end
