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
    @all_ratings = ['G','PG','PG-13','R']
    @rating_selection = params[:ratings]?params[:ratings]:session[:ratings]
    @sort_by_param = params[:sort_by_param]?params[:sort_by_param]:session[:sort_by_param]
    
    session[:sort] = @sort_by_param
    session[:ratings] = @rating_selection
    
    if @rating_selection
      @movies = Movie.where(:rating => @rating_selection.keys).order(params[:sort_by_param])
    else
       @movies = Movie.order(@sort_by_param)
    end
        
    if @sort_by_param == 'title' then
      @title_header = 'hilite'
    elsif @sort_by_param == 'release_date' then
    @release_date_header = 'hilite'
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

end
