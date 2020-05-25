# Write methods that return SQL queries for each part of the challeng here

require_relative '../db/seed.rb'

p 'The connections worked'



def guest_with_most_appearances
  sql =  <<-SQL 
  SELECT guest_name 
  FROM guests 
  GROUP BY guest_name 
  ORDER BY COUNT(guest_name) 
  DESC LIMIT 1;
  SQL

  answer = DB[:conn].execute(sql).first
  answer
  # write your query here!
end 

def most_popular_profession_per_year 
  sql =  <<-SQL 
  SELECT year, occupation
  FROM guests;
  SQL

  answer = DB[:conn].execute(sql)
  answer = answer.flatten
  final_result = []
  while answer.length != 0 do 
    this_year = {}
    year = answer.shift
    answer.delete(year)
    year_occupations = []
    while String === answer[0] && answer.length != 0 do
        year_occupations << answer.shift  
    end 
    most_common_occupation_this_year = year_occupations.max_by do |occupation|
      year_occupations.count(occupation)
    end 
    this_year[year] = most_common_occupation_this_year 
    final_result << this_year
  end  
  final_result
end 

def most_common_profession 
  sql = <<-SQL
  SELECT occupation 
  FROM guests
  GROUP BY occupation 
  ORDER BY COUNT(occupation)
  DESC LIMIT 1;
  SQL

  answer = DB[:conn].execute(sql).first 
  answer 
end 

def patrick_stewart_as_guest 
  sql = <<-SQL
  SELECT show
  FROM guests 
  WHERE guest_name = "Patrick Stewart";
  SQL

  answer = DB[:conn].execute(sql).flatten
end 

def year_with_most_guests
  sql = <<-SQL
  SELECT year, COUNT(year) AS cnt 
  FROM guests
  GROUP BY year 
  ORDER BY cnt DESC;
  SQL

  answer = DB[:conn].execute(sql).first 
  answer[0]
end 

def most_popular_group_per_year 
  sql =  <<-SQL 
  SELECT year, group_name
  FROM guests;
  SQL

  answer = DB[:conn].execute(sql)
  answer = answer.flatten
  final_result = []
  while answer.length != 0 do 
    this_year = {}
    year = answer.shift
    answer.delete(year)
    year_groups = []
    while String === answer[0] && answer.length != 0 do
        year_groups << answer.shift  
    end 
    most_common_group_this_year = year_groups.max_by do |occupation|
      year_groups.count(occupation)
    end 
    this_year[year] = most_common_group_this_year 
    final_result << this_year
  end  
  final_result
end 

def how_many_bills?
  sql = <<-SQL 
  SELECT guest_name 
  FROM guests;
  SQL

  answer = DB[:conn].execute(sql).flatten.uniq
  answer
  my_bills = answer.select do |name|
    /Bill / === name  
  end 
  my_bills.count
end 

binding.pry
0

