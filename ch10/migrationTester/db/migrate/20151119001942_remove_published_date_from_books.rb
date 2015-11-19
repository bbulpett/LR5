class RemovePublishedDateFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :published_date, :date
  end
end
