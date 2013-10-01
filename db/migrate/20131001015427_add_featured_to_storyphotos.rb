class AddFeaturedToStoryphotos < ActiveRecord::Migration
  def change
    add_column :storyphotos, :featured, :boolean
  end
end
