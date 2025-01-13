require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"
    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    # expect(user.username).to be("Pekka")

    expect(user.valid?).to be(false)
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    # let(:user){User.create username:"Pekka", password: "Secret1*", password_confirmation: "Secret1*"}
    let(:user) {FactoryBot.create(:user)}
    # let(:test_brewery){Brewery.new name: "Test", year:2000}
    # let(:test_beer){Beer.create name:"Testbeer", style:"Teststyle", brewery: test_brewery}
  
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end
  
    it "and with two ratings, has the correct average rating" do
      # rating = Rating.new score: 10, beer: test_beer
      # rating2 = Rating.new score: 20, beer: test_beer

      # user.ratings << rating
      # user.ratings << rating2

      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "password is not saved if" do
    it "it is too short" do
      user = User.create username:"Testuser", password: "abc", password_confirmation: "abc"
      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
    it "or if a capital letter is missing" do
      user = User.create username:"Testuser", password:"abcdef", password_confirmation: "abcdef"
      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
  end

  describe "favorite beer" do
    let(:user) {FactoryBot.create(:user)}
    it "has method for determining the favorite_beer" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score:20, beer: beer, user: user)
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      beer1 = FactoryBot.create(:beer)
      beer2 = FactoryBot.create(:beer)
      beer3 = FactoryBot.create(:beer)
      rating1 = FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
      rating2 = FactoryBot.create(:rating, score: 25, beer: beer2, user: user)
      rating3 = FactoryBot.create(:rating, score: 9,  beer: beer3, user: user)

      expect(user.favorite_beer).to eq(beer2)
    end
  end
  
  describe "favorite beer with auxiliary methods" do
    let(:user){FactoryBot.create(:user)}

    it "has method for determining the favorite beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with the highest rating if several rated" do
      create_beer_with_many_ratings({user: user}, 10, 20, 15, 7, 9)
      best = create_beer_with_rating({user: user}, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "EX3 favorite style" do
    let(:user) {FactoryBot.create(:user)}
    it "has method for determining the favorite style" do
      expect(user).to respond_to(:favorite_style)
    end
    
    it "without ratings does not have a favorite beer" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only style if only one rating" do
      beer = create_beer_with_rating_style({user: user}, 10, style:"Lager")
      expect(user.favorite_style).to eq("Lager")
    end

    it "is the style whose beers have the highest average rating if several rated" do
      create_beer_with_many_ratings_style({user: user}, 10, 20, 30, 34, 24, style:"IPA")
      create_beer_with_many_ratings_style({user: user}, 1, 2, 3, 1, 2, style:"Lager")
      create_beer_with_many_ratings_style({user: user}, 5, 5, 7, 21, 2, style:"Blonde")
      
      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "EX4 favorite brewery" do
    let(:user) {FactoryBot.create(:user)}
    it "has method for determining the favorite style" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only brewery if only one rating" do
      beer = create_beer_with_rating({user: user}, 10)
      expect(user.favorite_brewery).to eq(beer.brewery.name)
    end

    it "is the brewery whose beers have the highest average rating if several rated" do
      create_beer_with_many_ratings_brewery({user: user}, 1, 2, 3, 1, 2, brewery:"BBB")
      create_beer_with_many_ratings_brewery({user: user}, 10, 20, 30, 34, 24, brewery:"XXX")
      create_beer_with_many_ratings_brewery({user: user}, 5, 5, 7, 21, 2, brewery:"CCC")
      
      expect(user.favorite_brewery).to eq("XXX")
    end
  end
end

