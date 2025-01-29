class Style < ApplicationRecord
  extend Best
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  # def self.best(number)
  #   list = Rating.all.group_by { |r| r.beer.style }.map { |key, val| [key.name, val.sum(&:score) / val.size.to_f] }
  #   list.sort_by(&:last).reverse.first(number)
  # end

  # def self.best(how_many)
  #   sorted_by_rating_in_desc_order = all.sort_by{ |b| -(b.average_rating || 0) }
  #   sorted_by_rating_in_desc_order[0, how_many]
  # end

  def to_s
    name
  end
end
