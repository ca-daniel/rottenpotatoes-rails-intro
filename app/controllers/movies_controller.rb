class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     
    @all_ratings = Movie.all_ratings
    
    if params[:ratings].nil?
      @ratings_to_show = @all_ratings
    else
      @ratings_to_show = params[:ratings].keys
    end
    
    if params[:ratings].nil?
      @movies = Movie.all
    else
      @movies = Movie.where("rating IN (?)", @ratings_to_show)
    end
    
    if session[:current_title]
      @movies = Movie.all.order('title')
      session[:current_release] = nil
    end
    
    if session[:current_release]
      @movies = Movie.all.order('release_date')
      session[:current_title] = nil
    end
    
    
    if params[:order] == "title"
      @movies = Movie.all.order('title')
      @order_title = true
      session[:current_title] = true
      session[:current_release] = nil
    end
    
    if params[:order] == "release_date"
      @movies = Movie.all.order('release_date')
      @order_release = true
      session[:current_release] = true
      session[:current_title] = nil
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
  
  

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
