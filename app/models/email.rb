class Email < ActiveRecord::Base

  attr_accessible :digest, :email, :notify, :user_id
  
  belongs_to :user

  validates :email, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
  					format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

end
