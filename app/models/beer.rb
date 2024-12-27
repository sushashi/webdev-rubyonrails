class Beer < ApplicationRecord
    include RatingAverage

    belongs_to :brewery
    has_many :ratings, dependent: :destroy
    
    # def average_rating
    #     # self.ratings.sum(:score).to_f / self.ratings.count
    #     self.ratings.map {|i| i.score}.reduce(0,:+) / self.ratings.count.to_f
    # end

    def thing
        binding.pry
    end

    def to_s
        "#{self.brewery.name}: #{self.name}"
    end
end