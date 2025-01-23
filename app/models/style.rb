class Style < ApplicationRecord
  include RatingAverage

  has_many :beers

  def self.best(number)
    list = Rating.all.group_by { |r| r.beer.style }.map { |key, val| [key.name, val.sum(&:score) / val.size.to_f] }
    list.sort_by(&:last).reverse.first(number)
  end

  def to_s
    name
  end
end
