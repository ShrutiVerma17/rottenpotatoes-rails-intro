class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
    if ratings_list.empty?
      Movie.all
    else 
      where(rating: ratings_list)
    end
  end

  def self.all_ratings
    Movie.distinct.pluck(:rating)
  end
end
