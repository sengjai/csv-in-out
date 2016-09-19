require 'csv'
require 'byebug'
require 'date'

class Person
  # Look at the above CSV file
  # What attributes should a Person object have?
  attr_accessor :id, :first_name, :last_name, :email ,:phone, :created_at
  def initialize(hash)
    @id = hash[:id]
    @first_name = hash[:first_name]
    @last_name = hash[:last_name]
    @email = hash[:email]
    @phone = hash[:phone]
    @created_at = hash[:created_at]
  end
end

class PersonParser
  attr_reader :file
  
  def initialize(file)
    @file = file
    @people = []
  end

  def add_person(first_name,last_name,email,phone)
    @people << Person.new(id: @people.length+1, first_name: first_name,last_name: last_name,email: email,phone: phone,created_at: DateTime.now)
  end
  
  def people
    # If we've already parsed the CSV file, don't parse it again.
    # Remember: @people is +nil+ by default.
    CSV.foreach(@file, :headers => true, :header_converters => :symbol) do |csv_obj|
       @people << Person.new(csv_obj)
    end
    return @people
  end

  def save
    CSV.open("output.csv","w") do |csv|
        csv << ["id","first_name","last_name","email","phone","created_at"]
      @people.each do |elem|
        csv << [elem.id,elem.first_name,elem.last_name,elem.email,elem.phone,elem.created_at]
      end
    end
  end
end

parser = PersonParser.new('people.csv')
parser.people #returns 201 because of the header
parser.add_person("Brad","Jones","brad@gmail.com","0123455789")
parser.save

#puts "There are #{parser.people.size} people in the file '#{parser.file}'."
