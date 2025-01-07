class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true, }
  validate :validate_current_year

  def validate_current_year
    return unless year.present? && year > Date.current.year

    errors.add(:year, "Can't be in the future")
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end

  # def average_rating
  #     result = self.ratings.sum(:score).to_f / self.ratings.count
  #     result.nan? ? 0:result
  # end
end
