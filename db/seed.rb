# Parse the CSV and seed the database here! Run 'ruby db/seed' to execute this code.
# require_relative '../daily_show_guests.csv'
p "*" * 25
p "running 'seed.rb'"

require 'pry'
require 'csv'
require 'sqlite3'
require_relative '../config/environment.rb'

# DB = {:conn => SQLite3::Database.new("db/guests.db")}

class Guest
    attr_accessor :id, :guest_name, :occupation, :group_name, :year, :show 

    @@all = []
   
    def self.new_from_csv(csv_data)
      # Split the CSV data into an array of individual rows.
      rows = csv_data.split("\n")
      # For each row, let's collect a Person instance based on the data
        guests = rows.collect do |row|
        # Split the row into 3 parts, name, age, company, at the ", "
            data = row.split(",", 5)
            guest_name = data[4]
            occupation = data[1]
            group_name = data[3]
            year = data[0]
            show = data[2]
   
        # Make a new instance
            guest = self.new # self refers to the Person class. This is Person.new
        # Set the properties on the person.
            guest.guest_name = guest_name
            guest.occupation = occupation
            guest.group_name = group_name
            guest.show = show
            guest.year = year 
            guest.id = nil
        # Return the person to collect
            guest
        end
      # Return the array of newly created people.
    #   binding.pry
      guests.shift
      guests.each do |guest|
        guest.save 
      end   
      guests
    end

    def self.new_from_db(row)
        new_guest = self.new
        new_guest.id = row[0]
        new_guest.year = row[1]
        new_guest.occupation = row[2]
        new_guest.show = row[3]
        new_guest.group_name = row[4]
        new_guest.guest_name = row[5]
        new_guest
    end 
    
    def self.all 
        sql = <<-SQL
        SELECT *
        FROM guests
        SQL
 
        DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
        end
    end

    def self.create_table
        sql =  <<-SQL 
        CREATE TABLE IF NOT EXISTS guests (
            id INTEGER PRIMARY KEY,
            year INTEGER,
            occupation VARCHAR,
            show VARCHAR,
            group_name VARCHAR,
            guest_name VARCHAR
            );
            SQL

        DB[:conn].execute(sql) 
    end
     
    def save
        sql = <<-SQL
          INSERT INTO guests (
              year, 
              occupation,
              show,
              group_name,
              guest_name
              ) 
          VALUES (?, ?, ?, ?, ?)
        SQL
     
        DB[:conn].execute(sql, self.year, self.occupation, self.show, self.group_name, self.guest_name)
 
        self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM guests")[0][0]
    end

    def self.drop_table 
        sql =  <<-SQL 
        DROP TABLE IF EXISTS guests;
            SQL

        DB[:conn].execute(sql) 
    end 

end

Guest.drop_table
Guest.create_table
csv_text = File.read('./daily_show_guests.csv')
data = Guest.new_from_csv(csv_text)
# binding.pry
0