class CreateBookWithColumnsAndIndex < ActiveRecord::Migration
  def change
    create_table :book_with_columns_and_indices do |t|
      t.string :title
      t.string :author
      t.integer :isbn
      t.float :price
      t.date :published_date
    end

    # Add an index to speed up searches of ISBN numbers
    add_index :book_with_columns, :isbn
  end
end
