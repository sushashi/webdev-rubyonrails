module Helpers

	def sign_in(credentials)
		visit signin_path
		fill_in('username', with: credentials[:username])
		fill_in('password', with: credentials[:password])
		click_button('Log in')
	end

	def create_beer_with_many_ratings_brewery(object, *scores, brewery:)
		scores.each do |score|
			create_beer_with_rating_brewery(object, score, brewery: brewery)
		end
	end

	def create_beer_with_rating_brewery(object, score, brewery:)
		bb = FactoryBot.create(:brewery, name: brewery )
		beer = FactoryBot.create(:beer, brewery: bb)
		FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
		beer
	end

	def create_beer_with_many_ratings_style(object, *scores, style:)
		scores.each do |score|
			create_beer_with_rating_style(object, score, style: style)
		end
	end

	def create_beer_with_rating_style(object, score, style:)
		beer = FactoryBot.create(:beer, style: style)
		FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
		beer
	end

	def create_beer_with_rating(object, score)
		beer = FactoryBot.create(:beer)
		FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
		beer
	end

	def create_beer_with_many_ratings(object, *scores)
		scores.each do |score|
			create_beer_with_rating(object, score)
		end
	end
end