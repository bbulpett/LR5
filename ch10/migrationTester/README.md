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


		