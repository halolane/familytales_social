class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email
      t.integer :user_id
      t.boolean :notify
      t.boolean :digest

      t.timestamps
    end
  end
end
