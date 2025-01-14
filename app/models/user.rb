class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }

  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[^A-Za-z0-9]).{4,}\z/,
                                 message: "must contain at least 4 characters, at least 1 capital letter and 1 special figure" }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings

  has_many :memberships, dependent: :destroy
  has_many :beerclubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?

    # ratings.sort_by{|r| r.score}.last.beer
    # ratings.sort_by(&:score).last.beer
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    # puts "there are #{Beer.count} beers"
    # puts "Style #{Beer.all.sort_by{|r| r.average_rating}.last.style}"
    # beers.all.sort_by{ |r| r.average_rating }.last.style
    beers.all.max_by(&:average_rating).style
  end

  def favorite_brewery
    return nil if ratings.empty?

    # beers.all.sort_by{ |r| r.average_rating }.last.brewery.name
    beers.all.max_by(&:average_rating).brewery.name
  end
end
