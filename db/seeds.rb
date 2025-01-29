# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# if your computer is fast, you can increase the below numbers
users = 50             
breweries = 50
beers_in_brewery = 50
ratings_per_user = 30

(1..users).each do |i|
  User.create! username: "user_#{i}", password: "passworD*", password_confirmation: "passworD*"
end

(1..breweries).each do |i|
  Brewery.create! name: "Brewery_#{i}", year: 1900, active: true
end

bulk = Style.create! name: "Bulk", description: "cheap, not much taste"

Brewery.all.each do |b|
  n = rand(beers_in_brewery)
  (1..n).each do |i|
    beer = Beer.create! name: "Beer #{b.id} -- #{i}", style: bulk, brewery: b
    b.beers << beer
  end
end

User.all.each do |u|
  n = rand(ratings_per_user)
  beers = Beer.all.shuffle
  (1..n).each do |i|
    r = Rating.new score:(1+rand(50))
    beers[i].ratings << r
    u.ratings << r
  end
end