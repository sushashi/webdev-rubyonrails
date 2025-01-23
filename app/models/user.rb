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

  def self.most_active_users(number)
    User.all.sort_by{ |u| - u.ratings.count }.first(number)
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  # def favorite_style
  #   favorite(:style)
  # end

  # def favorite_brewery
  #   favorite(:brewery)
  # end

  # favorite_available_by :style, :brewery

  def method_missing(method_name, *args, &)
    return super unless method_name =~ /^favorite_/

    category = method_name[9..].to_sym
    favorite category
  end

  def respond_to_missing?(method_name, include_private = false)
    method_name.to_s.start_with?('favorite_') || super
  end

  def favorite(groupped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by{ |r| r.beer.send(groupped_by) }
    averages = grouped_ratings.map { |group, ratings| { group: group, score: average_of(ratings) } }

    averages.max_by{ |r| r[:score] }[:group]
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end
end
