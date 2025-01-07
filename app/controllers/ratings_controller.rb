class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    # save the created rating into a variable
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      # save the rating to a session
      session[:last_rating] = "#{@rating.beer.name} #{@rating.score} points"

      redirect_to current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end

    # binding.pry
    # puts "print out #{params[:rating]}"
    # raise
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
