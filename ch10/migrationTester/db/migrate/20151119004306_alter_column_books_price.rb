class AlterColumnBooksPrice < ActiveRecord::Migration
  def change
  	change_column :books, :price, precision: 7, scale: 2
  end
end
