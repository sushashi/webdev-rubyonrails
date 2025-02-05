class Brewery < ApplicationRecord
  extend Best
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true, }
  validate :validate_current_year

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  # def self.best(number)
  #   Brewery.all.sort_by{ |b| - b.average_rating }.first(number)
  # end

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

  after_create_commit do
    if active
      target_id = "active_brewery_rows"
      target_count = "active_count"
    else
      target_id = "retired_brewery_rows"
      target_count = "retired_count"
    end
    broadcast_update_to "breweries_index", target: target_count, html: Brewery.where(active: target_count == "active_count").count
    broadcast_append_to "breweries_index", partial: "breweries/brewery_row", target: target_id, locals: { current_user: { admin: true } }
  end

  after_destroy_commit do
    target_count = if active
                     "active_count"
                   else
                     "retired_count"
                   end
    broadcast_update_to "breweries_index", target: target_count, html: Brewery.where(active: target_count == "active_count").count
    broadcast_remove_to "breweries_index", target: "brewery_#{id}"
  end

  after_update_commit do
    broadcast_update_to "breweries_index", target: "active_count", html: Brewery.where(active: true).count
    broadcast_update_to "breweries_index", target: "retired_count", html: Brewery.where(active: false).count

    broadcast_remove_to "breweries_index", target: "brewery_#{id}"

    target_id = if active
                  "active_brewery_rows"
                else
                  "retired_brewery_rows"
                end
    broadcast_append_to "breweries_index", partial: "breweries/brewery_row", target: target_id, locals: { current_user: { admin: true } }
  end
end
