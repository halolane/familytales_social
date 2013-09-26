class AddCharactersToStories < ActiveRecord::Migration
  def change
    add_column :stories, :characters, :string
  end
end
