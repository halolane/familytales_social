class CreateStoryphotos < ActiveRecord::Migration
  def change
    create_table :storyphotos do |t|

      t.timestamps
    end
  end
end
