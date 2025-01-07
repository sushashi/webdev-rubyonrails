module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    result = ratings.map(&:score).reduce(0, :+) / ratings.count.to_f
    # result = self.ratings.map { |i| i.score }.reduce(0, :+) / self.ratings.count.to_f
    # result = self.ratings.sum(:score).to_f / self.ratings.count
    result.nan? ? 0 : result
  end
end
