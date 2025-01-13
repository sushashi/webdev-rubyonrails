class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  # def average_rating
  #     # self.ratings.sum(:score).to_f / self.ratings.count
  #     self.ratings.map {|i| i.score}.reduce(0,:+) / self.ratings.count.to_f
  # end

  validates :name, presence: true
  validates :style, presence: true
  def thing
    # binding.pry
  end

  def to_s
    "#{brewery.name}: #{name}"
  end
end
