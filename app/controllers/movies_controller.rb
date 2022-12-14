class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if (params[:home].nil?)
      @ratings_to_show = []
      if (!session[:ratings_to_show].nil?)
        @ratings_to_show = session[:ratings_to_show]
      end
      @column_to_sort = session[:column_to_sort]
    end
    if (!params[:ratings].nil?)
      @ratings_to_show = params[:ratings].keys
    elsif (@ratings_to_show.nil?)
      @ratings_to_show = []
    end
    if (!params[:column_clicked].nil?)
      @column_to_sort = params[:column_clicked]
    end
    movies_subset = Movie.with_ratings(@ratings_to_show)
    if (@column_to_sort.nil?)
      @movies = movies_subset
    else
      @movies = movies_subset.order(@column_to_sort)
    end
    session[:ratings_to_show] = @ratings_to_show
    session[:column_to_sort] = @column_to_sort
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
