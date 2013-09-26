class AddLessonToStories < ActiveRecord::Migration
  def change
    add_column :stories, :lesson, :string
  end
end
