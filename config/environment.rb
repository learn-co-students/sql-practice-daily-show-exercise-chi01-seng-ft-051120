p "*" * 25
p "running 'environment.rb'"

require 'bundler'
Bundler.require

# Setup a DB connection here
require 'sqlite3'
# require_relative '../db/seed.rb'
 
DB = {:conn => SQLite3::Database.new("db/guests.db")}
