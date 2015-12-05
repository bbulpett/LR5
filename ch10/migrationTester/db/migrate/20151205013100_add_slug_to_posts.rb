class AddSlugToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :slug, :string, index: true
  end
end
