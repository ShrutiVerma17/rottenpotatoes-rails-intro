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

  def self.sort(column_to_sort)
    if column_to_sort.empty?
      return
    else
      order(column_to_sort)
    end
  end
end
