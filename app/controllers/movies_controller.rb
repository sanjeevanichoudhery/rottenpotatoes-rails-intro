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
    
    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      params[:sort] = session[:sort_by]
    else
      params[:sort] = nil
    end

    if params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      params[:ratings] = session[:ratings]
    else
      params[:ratings] = nil
    end

    
    
    
    if params[:sort] and params[:ratings]
      @movies = Movie.where(:rating => @selected_ratings).order(params[:sort])
    elsif params[:ratings]
      @movies = Movie.where(:rating =>@selected_ratings)
    elsif params[:sort]
      @movies = Movie.order(params[:sort])
    else
      @movies = Movie.all
    end  

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
