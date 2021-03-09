require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  # initialize
  def initialize(attributes = {})
    @id = attributes["id"]
    @name = attributes["name"]
    @grade = attributes["grade"]
  end

  # create table
  def self.create_table
    sql = <<-SQL
            CREATE TABLE IF NOT EXISTS students (
                id INTEGER PRIMARY KEY,
                name TEXT,
                grade TEXT
            );
    SQL

    DB[:conn].execute(sql)
  end

  # drop table
  def self.drop_table
    sql = 'DROP TABLE IF EXISTS students'

    DB[:conn].execute(sql)
  end

  # save
  def save
    # checks if exists in db, if not, then update record
    # binding.pry
    if self.class.find(@id)
      sql = <<-SQL
                UPDATE students
                SET name = ?, grade = ?
                WHERE id = ?
      SQL

      DB[:conn].execute(sql, @grade, @name, @id)
      # new record, doesn't exist in my db
    else
      sql = <<-SQL
                INSERT INTO students (name, grade)
                VALUES (?, ?);
      SQL

      DB[:conn].execute(sql, @name, @grade)
    end
    self
  end

  # create
  def self.create(attributes)
    new(attributes).save
  end

  # new from DB
  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  # self.all
  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
          SELECT *
          FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      new_from_db(row)
    end
  end

  # find by name
  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      new_from_db(row)
    end.first
  end

  # update
  def self.update
    self.find_by_name(name)
  end

end
