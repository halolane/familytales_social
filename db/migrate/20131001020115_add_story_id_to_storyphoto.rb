class AddStoryIdToStoryphoto < ActiveRecord::Migration
  def change
    add_column :storyphotos, :story_id, :integer
  end
end
