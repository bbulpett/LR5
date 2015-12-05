#LR5
##Chapter 10
###"Managing Databases with Migrations"

A migration is a set of instructions for changing, adding, or removing database structures in a Rails application. Migrations are implemented and rolled back using specific `rake` commands. The application for this chapter, *migrationTester*, contains a variety of migration examples which are located in the *db/migrate* directory.

#####"Migration Files"

To generate a new migration, use the command syntax `rails generate migration NameOfMigration` in the terminal. It is helpful to choose a semantic, meaningful name for the migration to help find it later. The name can be in *CamelCase* or with *underscores_between_words*. Either way, Rails will understand and append it to a timestamp. 

A basic, empty migration created with the command `rails g migration EmptyMigration` will create a following migration file (*db/migrate/20151110005156_empty_migration.rb*) with the following code:

		class EmptyMigration < ActiveRecord::Migration
			def change
			end
		end

As shown in Chapter 9, creating tables complete with columns and data types is fairly simple using migrations. At the time of this writing, the **change** method supports the following definitions, which Rails knows how to "reverse" should the migration be rolled back:

		add_column
		add_foreign_key
		add_index
		add_reference
		add_timestamps
		change_column_default (must supply a :from and :to option)
		change_column_null
		create_join_table
		create_table
		disable_extension
		drop_join_table
		drop_table (must supply a block)
		enable_extension
		remove_column (must supply a type)
		remove_foreign_key (must supply a second table)
		remove_index
		remove_reference
		remove_timestamps
		rename_column
		rename_index
		rename_table

**NOTE:** When using any other definitions in a migration (the use of executable SQL statements for instance), the following syntax can be used instead of the **change** method:

		class MigrationName < ActiveRecord::Migration
			def self.up
				# some irreversible method
			end

			def self.down
				# opposite of irreversible method
			end
		end

#####"Inside Migrations"

When Rails *scaffolding* is used to generate the model, controller, and views for an object a migration is also generated. For example, the following migration was created in Chapter 9 with the **scaffolding** command:

		class CreateStudents < ActiveRecord::Migration
			def change
				create_table :students do |t|
					t.string :given_name
					t.string :middle_name
					t.string :family_name
					t.date :date_of_birth
					t.decimal :grade_point_average
					t.date :start_date

					t.timestamps
				end
			end
		end

Running this migration to add the **Student** model to the schema was simple, using the command `rake db:migrate`. Since Rails is able to reverse the **create_table** method, it can be removed by running `rake db:rollback`.

Migrations can be plain and empty or more robust. The following migration would build a migration with an empty table called "Books"...

		rails generate migration CreateBook

This produces a file (*db/migrate/20151110012135_create_book.rb*) with the following code:

		class CreateBook < ActiveRecord::Migration
			def change
				create_table :books do |t|
				end
			end
		end

The columns may then be added within the **create_table** method, as above, prefixed with **t.**

Just as columns can be added to a migration generated with scaffolding, these attributes can also be specified when generating a simple table like the one above. The following command generates the **Books** table with some basic columns:

		rails generate migration CreateBookWithColumns title:string author:string isbn:integer price:float published_date:date

..which produces the following migration file (*db/migrate/20151117015213_create_book_with_columns*):

		class CreateBookWithColumns < ActiveRecord::Migration
			def change
				create_table :book_with_columns do |t|
					t.string :title
					t.string :author
					t.integer :isbn
					t.float :price
					t.date :published_date
				end
			end
		end

#####"Data Types"

Before a migration is run, named parameters can be added to columns depending on their data type. For example, one might edit the preceding migration to read as follows:

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

#####"Working with Columns"

Once the application has been established, table columns may still be added, removed, or changed with a standalone migration. For instance, if the **Books** table created in the previous section needed to specify the language in which books are written, simply create a migration with `rails g migration AddLanguageToBooks language:string`, which creates the following file (*20151119000940_add_language_to_book.rb*):

		class AddLanguageToBook < ActiveRecord::Migration
			def change
				add_column :books, :language, :string
			end
		end

Columns that are deemed to be unnecessary can be removed in similar fashion. A command such as the following will do the trick: `rails g migration RemovePublished_dateFromBooks published_date:date`. The following file is created (*201511190001942_remove_published_date_from_books.rb*):

        class RemovePublishedDateFromBooks < ActiveRecord::Migration
          def change
            remove_column :books, :published_date, :date
          end
        end

There are also "plural" versions of these methods - **add_columns** and **remove_columns** to speed up the alteration of multiple columns at once. Similarly, existing columns can easily be changed. For example, if the price of books were to skyrocket, one could create a migration with `rails g migration alter_column_books_price`. This will generate a migration file with an empty **change** method, wherein the column may be redefined (*20151119004306_alter_column_books_price.rb*)...

        class AlterColumnBooksPrice < ActiveRecord::Migration
          def change
            change_column :books, :price, precision: 7, scale: 2
          end
        end


There are a multitude of instance methods and transformations available for ActiveRecord migrations. More information can be found at *http://edgeguides.rubyonrails.org/active_record_migrations.html* and *http://apidock.com/rails/ActiveRecord/Migration*.

#####"Indexes"

Rails is set up so that databases automatically index the **id** column of a table. If a table has other columnns that will be regularly searched, such as foreign key columns used in join tables, adding an index can speed up those searches. Indexes can be added in a number of ways. Perhaps the most common method is to add it when generating the table. For instance, in Chapter 9 we generated the following *join table*, which included indexes for both tables:

        class CreateJoinTableCourseStudent < ActiveRecord::Migration
          def change
            create_join_table :courses, :students do |t|
              t.index [:course_id, :student_id]
              t.index [:student_id, :course_id]
            end
          end
        end

Perhaps the above **Books** table could also use an index to speed the search of volumes by their ISBN numbers. This could have been added easily by adding **add_index** to the migration used to create the table..

      
        class CreateBookWithColumnsAndIndex < ActiveRecord::Migration
          def change
            create_table :book_with_columns do |t|
              t.string :title
              t.string :author
              t.integer :isbn
              t.float :price
              t.date :published_date
            end

            add_index :book_with_columns, :isbn
          end
        end
        
The `add_index` method (and its counterpart, `remove_index`) is quite versatile in that it can be added to virtually any migration, even by itself in a "standalone" migration. Indexes may also be created via the addition of a boolean `index` modifier within a column definition. For example, the following migration adds a column to store a "slug" (human readable id) for posts in a blog application..

        class AddSlugToPosts < ActiveRecord::Migration
          def change
            add_column :posts, :slug, :string, index: true
          end
        end

This simple migration was created with the command `rails g migration AddSlugToPosts`. Then, in the text editor, `index: true` modifier is added to the new column's parameter list. Remember that indexes should always be added only *after* their respective tables and columns already exist. This way, the index can be removed without error by using the `rake db:rollback` command.

#####"Other Opportunities"

Among the many available transformation methods available to Rails migrations are:

        add_belongs_to
        add_column
        add_foreign_key
        add_index
        add_index_options
        add_index_sort_order
        add_reference
        add_timestamps
        assume_migrated_upto_version
        change_column
        change_column_default
        change_column_null
        change_table
        column_exists?
        columns
        columns_for_distinct
        create_alter_table
        create_join_table
        create_table
        create_table_definition
        drop_join_table
        dump_schema_information
        foreign_key_column_for
        foreign_key_name
        foreign_keys
        index_exists?
        index_name
        index_name_exists?
        index_name_for_remove
        initialize_schema_migrations_table
        native_database_types
        options_include_default?
        quoted_columns_for_index
        remove_belongs_to
        remove_column
        remove_columns
        remove_foreign_key
        remove_index
        remove_index!
        remove_reference
        remove_timestamps
        rename_column
        rename_column_indexes
        rename_index
        rename_table
        rename_table_indexes
        table_alias_for
        table_exists?
        type_to_sql
        update_table_definition
        validate_index_length!

With each version of Rails this list changes and it should be noted that some of these methods are seldom actually used. Nonetheless, it is clear that there are a great many tasks, from managing database connections to renaming a simple column, that can be automated using Rails migrations. A good reference on the usage of these methods can be found at *http://apidock.com/rails*.

		