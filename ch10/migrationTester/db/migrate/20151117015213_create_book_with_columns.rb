class CreateBookWithColumns < ActiveRecord::Migration
  def change
    create_table :book_with_columns do |t|
      t.string :title, limit: 100 ### entries will be limited to 100 characters and cannot be left empty
			t.string :author, limit: 45 ### entries will be limited to 45 characters
			t.integer :isbn, limit: 13 ### entries will be limited to 13 characters
			t.decimal :price, precision: 6, scale: 2 ### entries will follow the format "xxxx.xx"
			t.date :published_date, default: Date.today ### this sets the default value to today's date. However, this is not automatically persisted to the model and will be overwritten with user-entered data.
    end
  end
end
