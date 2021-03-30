user=User.new(
    email: "ali@gmail.com",
    password: "12345678",
    password_confirmation: "12345678"
)

user.skip_confirmation!
user.save


Course.delete_all
PublicActivity.enabled=false
50.times do 
    Course.create([{ 
        title: Faker::Educator.course_name,
        description: Faker::Restaurant.description,
        user_id: User.first.id,
        short_description: Faker::Quote.famous_last_words,
        language: Faker::ProgrammingLanguage.name,
        level: 'Beginner',
        price: Faker::Number.between(from:100, to:1000)

        }])
end

PublicActivity.enabled=true

