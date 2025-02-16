class RatingsController < ApplicationController
  before_action :empty_cache, only: [:create, :destroy]
  before_action :set_rating, only: [:show]
  PAGE_SIZE = 5

  def empty_cache
    expire_fragment('brewerieslist')
    %w(beerlist-name beerlist-brewery beerlist-style).each{ |f| expire_fragment(f) }
  end

  def index
    @rating_page = params[:rating_page]&.to_i || 1
    @rating_last_page = (Rating.count / PAGE_SIZE.to_f).ceil
    offset = (@rating_page - 1) * PAGE_SIZE

    @ratings = Rating.recent.limit(PAGE_SIZE).offset(offset)

    # @ratings = Rating.all

    # @beers_best_three = Beer.best(3)
    # @breweries_best_three = Brewery.best(3)
    # @last_five_ratings = Rating.recent
    # @best_three_styles = Style.best(3)
    # @most_active_users = User.most_active_users(3)

    Rails.cache.write("beer top 3", Beer.best(3)) if Rails.cache.read("beer top 3").nil?
    Rails.cache.write("brewery top 3", Brewery.best(3)) if Rails.cache.read("brewery top 3").nil?
    # Rails.cache.write("recent ratings", Rating.recent) if Rails.cache.read("recent ratings").nil?
    Rails.cache.write("style top 3", Style.best(3)) if Rails.cache.read("style top 3").nil?
    Rails.cache.write("active user top 3", User.most_active_users(3)) if Rails.cache.read("active user top 3").nil?

    CacheRatings.perform_async # perform job every 10 min

    @beers_best_three = Rails.cache.read "beer top 3"
    @breweries_best_three = Rails.cache.read "brewery top 3"
    # @last_five_ratings = Rails.cache.read "recent ratings"
    @best_three_styles = Rails.cache.read "style top 3"
    @most_active_users = Rails.cache.read "active user top 3"
  end

  def new
    @rating = Rating.new
    @beers = Beer.includes(:brewery).all
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

  def show
    return unless turbo_frame_request?

    render partial: 'rating_details', locals: { rating: @rating }
  end

  def destroy
    destroy_ids = request.body.string.split(',')

    destroy_ids.each do |id|
      rating = Rating.find_by(id: id)
      rating.destroy if rating && current_user == rating.user
    rescue StandardError => e
      puts "Rating record has an error: #{e.message}"
    end

    @user = current_user
    respond_to do |format|
      format.html { render partial: '/users/ratings', stauts: :ok, user: @user }
    end
    # rating = Rating.find(params[:id])
    # rating.delete if current_user == rating.user
    # redirect_to user_path(current_user)
  end

  private

  def set_rating
    @rating = Rating.find(params.expect(:id))
  end
end
