class AddTweetAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tweet_avatar, :string
  end
end
