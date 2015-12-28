class AlterColumnBooksPrice < ActiveRecord::Migration
  # def change
  # 	change_column :books, :price, precision: 7, scale: 2
  # end

  # change_column is not reversible. We should use self.up and self.down instead.
  def self.up
    change_column :books, :price, precision: 7, scale: 2  #Change the price column to accept 7 digits
  end
  
  def self.down
    change_column :books, :price, precision: 6, scale: 2  #Revert the price column back to 6 digits
  end
end
