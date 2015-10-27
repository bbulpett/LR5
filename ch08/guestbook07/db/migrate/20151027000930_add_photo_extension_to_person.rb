class AddPhotoExtensionToPerson < ActiveRecord::Migration
  def change
  	add_column :people, :extension, :string
  end
end
