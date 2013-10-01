class AddAttachmentPhotoToStoryphotos < ActiveRecord::Migration
  def self.up
    change_table :storyphotos do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :storyphotos, :photo
  end
end
