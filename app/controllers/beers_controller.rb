class BeersController < ApplicationController
  before_action :set_beer, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]
  before_action :ensure_that_admin, only: [:destroy]
  before_action :empty_cache, only: [:create, :destroy, :update]
  PAGE_SIZE = 20

  def empty_cache
    expire_fragment('brewerieslist')
    %w(beerlist-name beerlist-brewery beerlist-style beerlist-rating).each{ |f| expire_fragment(f) }
  end

  def list
  end

  def ensure_that_admin
    raise "You must be an administrator" unless current_user.admin?
  end

  # GET /beers or /beers.json
  def index
    @beer_tot = Beer.all.count
    @order = params[:order] || 'name'
    @page = params[:page]&.to_i || 1
    @last_page = (Beer.count / PAGE_SIZE.to_f).ceil
    offset = (@page - 1) * PAGE_SIZE

    @beers = Beer.order(:name).limit(PAGE_SIZE).offset(offset)

    @beers = case @order
             when "name"    then Beer.order(:name)
                                     .limit(PAGE_SIZE).offset(offset)
             when "brewery" then Beer.joins(:brewery)
                                     .order("breweries.name").limit(PAGE_SIZE).offset(offset)
             when "style"   then Beer.joins(:style)
                                     .order("styles.name").limit(PAGE_SIZE).offset(offset)
             when "rating"  then Beer.left_joins(:ratings)
                                     .select("beers.*, avg(ratings.score)")
                                     .group("beers.id")
                                     .order("avg(ratings.score) DESC").limit(PAGE_SIZE).offset(offset)
             end

    if turbo_frame_request?
      render partial: "beer_list",
             locals: { beers: @beers, page: @page, order: @order, last_page: @last_page }
    else
      render :index
    end

    # if fragment exist, stop the method here (i.e. render the view immediately)
    # return if request.format.html? && fragment_exist?("beerlist-#{@order}")

    # @beers = Beer.includes(:brewery, :style, :ratings).all
    # @beers = Beer.all

    # @beers = case @order
    #          when "name" then @beers.sort_by(&:name)
    #          when "brewery" then @beers.sort_by { |b| b.brewery.name }
    #          when "style" then @beers.sort_by { |b| b.style.name }
    #          when "rating" then @beers.sort_by(&:average_rating).reverse
    #          end
  end

  # GET /beers/1 or /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  # GET /beers/new
  def new
    @beer = Beer.new
    @breweries = Brewery.all
    @styles = Style.all
  end

  # GET /beers/1/edit
  def edit
    @breweries = Brewery.all
    @styles = Style.all
  end

  # POST /beers or /beers.json
  def create
    @beer = Beer.new(beer_params)

    # Beer.create params.require(:beer).permit(:name, :style, :brewery_id)
    # redirect_to beers_path

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: "Beer was successfully created." }
        format.json { render :show, status: :created, location: @beer }
      else
        @breweries = Brewery.all
        @styles = Style.all
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1 or /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: "Beer was successfully updated." }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1 or /beers/1.json
  def destroy
    @beer.destroy!

    respond_to do |format|
      format.html { redirect_to beers_path, status: :see_other, notice: "Beer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beer
    @beer = Beer.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def beer_params
    params.expect(beer: [:name, :style_id, :brewery_id])
  end
end
