require 'rails_helper'
include Helpers

describe "EX5 Beers page" do
	let!(:brewery) {FactoryBot.create :brewery, name: "Brewertest"}

	it "can add a new beer with valid name" do
		visit new_beer_path
		fill_in('beer[name]', with: 'TestBeer')
		select('Brewertest', from: 'beer[brewery_id]')
		click_button "Create Beer"

		expect(page).to have_content("Beer was successfully created")
		expect(Beer.count).to eq(1)
	end

	it "wont add a new beer with a non valid name" do
		visit new_beer_path
		click_button "Create Beer"
		# puts page.html
		
		expect(current_path).to eq("/beers")
		expect(page).to have_content("prohibited this beer from being saved")
		expect(Beer.count).to eq(0)
	end
end

describe "EX6 Ratings page with total amount" do
	let!(:user){FactoryBot.create :user}

	it "Ratings are shown in the page ratings" do
		create_beer_with_many_ratings_brewery({user: user}, 1, 2, 3, 1, 2, brewery:"BBB")
		create_beer_with_many_ratings_brewery({user: user}, 10, 20, 30, 34, 24, brewery:"XXX")

		visit ratings_path
		expect(Rating.count).to eq(10)
		expect(page).to have_content("There are #{Rating.count} ratings")
	end
end

describe "EX7 User ratings are shown in their page" do
	let!(:user1){FactoryBot.create :user, username:"user01"}
	let!(:user2){FactoryBot.create :user, username:"user02"}
	let!(:user3){FactoryBot.create :user, username:"user03"}

	it "show all the user's personal ratings but not the ratings made by other users" do
		create_beer_with_many_ratings_brewery({user: user1}, 1, 2, 3, 4, 5, brewery:"BBB")
		create_beer_with_many_ratings_brewery({user: user2}, 10, 20, 30, 34, 24, brewery:"XXX")
		create_beer_with_many_ratings_brewery({user: user3}, 6, 7, 8, 9, 22, brewery:"XXX")

		visit user_path(1)
		puts page.html
		# for i in 1..5
		# 	expect(page).to have_content("anonymous, #{i}")
		# end
		expect(page).to have_content("anonymous, 1")
		expect(page).to have_content("anonymous, 2")
		expect(page).to have_content("anonymous, 3")


		expect(page).not_to have_content("anonymous, 10")
		expect(page).not_to have_content("anonymous, 8")
	end
end

describe "EX8 User delete own rating" do
	let!(:user){FactoryBot.create :user}

	it "When delete own rating, it is removed from the database" do
		create_beer_with_many_ratings_brewery({user: user}, 1, 2, 3, 4, 5, brewery:"BBB")
		sign_in(username: "Pekka", password: "Foobar1*")
		visit user_path(1)
		puts page.html
		using_wait_time(10) do
			find("#list-ratings") do
				item = find("li", text:"anonymous, 2")
				item.click_link("Delete")
			end
		end
		expect(page).not_to have_content("anonymous, 2")
		expect(page).to have_content("anonymous, 1")

		expect(user.ratings.find_by score: 2).to eq(nil)
		expect(user.ratings.find_by score: 1).to eq(Rating.find_by score: 1)
	end
end

describe "EX9 favorite style and brewery" do
	let!(:user){FactoryBot.create :user}

	it "User page contains favorite brewery based on ratings" do
		create_beer_with_many_ratings_brewery({user: user}, 1, 2, 3, 4, 5, brewery:"BBB")
		create_beer_with_many_ratings_brewery({user: user}, 10, 20, 30, 34, 24, brewery:"XXX")
		create_beer_with_many_ratings_brewery({user: user}, 6, 7, 8, 9, 22, brewery:"XXX")

		visit user_path(1)
		expect(page).to have_content("favorite brewery: XXX")
	end

	it "User page contains favorite style based on ratings" do
		create_beer_with_many_ratings_style({user: user}, 1, 2, 3, 4, 5, style:"Lager")
		create_beer_with_many_ratings_style({user: user}, 10, 20, 30, 34, 24, style:"IPA")
		create_beer_with_many_ratings_style({user: user}, 6, 7, 8, 9, 22, style:"Blonde")
		
		visit user_path(1)
		expect(page).to have_content("favorite style: IPA")
	end
end