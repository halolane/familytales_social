class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.string :subtitle
      t.text :body, :limit => nil

      t.timestamps
    end
  end
end
