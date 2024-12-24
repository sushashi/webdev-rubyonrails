class Rating < ApplicationRecord
    belongs_to :beer

    def to_s
        "written rating"
    end
end
