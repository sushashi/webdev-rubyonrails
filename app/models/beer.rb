class Beer < ApplicationRecord
  extend Best
  include RatingAverage

  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  belongs_to :style

  validates :name, presence: true
  validates :style_id, presence: true

  # def self.best(number)
  #   Beer.all.sort_by{ |b| - b.average_rating }.first(number)
  # end

  def to_s
    "#{brewery.name}: #{name}"
  end
end
