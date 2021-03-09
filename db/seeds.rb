require 'faker'

class Seed
  def self.seed_data
    5.times do
      Student.create({
                       "id" => nil,
                       "name" => Faker::Name.name,
                       "grade" => Faker::Number.number(digits: 2)
                     }).save
    end
  end
end

# (1..5).each do |id|
#   Student.create(
#     id: id,
#     name: Faker::Name.name,
#     grade: Faker::Number.number(digits: 2)
#
#   )
# end
