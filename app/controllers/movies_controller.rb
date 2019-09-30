class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings=Movie.select(:rating).map(&:rating).uniq #https://stackoverflow.com/questions/8369812/rails-how-can-i-get-unique-values-from-column
    @selected_ratings = checked_ratings
    @movies=Movie.all
    @movies = Movie.order(params[:sort])
    @movies = Movie.where(:rating => @selected_ratings)
      #https://stackoverflow.com/questions/19968638/refactoring-ruby-on-rails-link-to-with-sorting
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
  def checked_ratings
    if params[:ratings]
      params[:ratings].keys
    else
      @all_ratings
    end
  end
end
