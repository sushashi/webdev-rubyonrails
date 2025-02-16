class BeerclubsController < ApplicationController
  before_action :set_beerclub, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :ensure_that_admin, only: [:destroy]

  def ensure_that_admin
    raise "You must be an administrator" unless current_user.admin?
  end

  # GET /beerclubs or /beerclubs.json
  def index
    @beerclubs = Beerclub.all
    order = params[:order] || 'name'
    @beerclubs = case order
                 when 'name' then @beerclubs.sort_by(&:name)
                 when 'city' then @beerclubs.sort_by(&:city)
                 when 'founded' then @beerclubs.sort_by(&:founded).reverse
                 end
  end

  # GET /beerclubs/1 or /beerclubs/1.json
  def show
    @membership = Membership.new
    @is_member = Membership.find_by(user_id: current_user.id, beerclub_id: @beerclub.id) if current_user
    # @membership.user = current_user
    # @membership.beerclub = @beerclub
  end

  # GET /beerclubs/new
  def new
    @beerclub = Beerclub.new
  end

  # GET /beerclubs/1/edit
  def edit
  end

  # POST /beerclubs or /beerclubs.json
  def create
    @beerclub = Beerclub.new(beerclub_params)

    respond_to do |format|
      if @beerclub.save
        format.html { redirect_to @beerclub, notice: "Beerclub was successfully created." }
        format.json { render :show, status: :created, location: @beerclub }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beerclub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beerclubs/1 or /beerclubs/1.json
  def update
    respond_to do |format|
      if @beerclub.update(beerclub_params)
        format.html { redirect_to @beerclub, notice: "Beerclub was successfully updated." }
        format.json { render :show, status: :ok, location: @beerclub }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beerclub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beerclubs/1 or /beerclubs/1.json
  def destroy
    @beerclub.destroy!

    respond_to do |format|
      format.html { redirect_to beerclubs_path, status: :see_other, notice: "Beerclub was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beerclub
    @beerclub = Beerclub.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def beerclub_params
    params.expect(beerclub: [:name, :founded, :city])
  end
end
