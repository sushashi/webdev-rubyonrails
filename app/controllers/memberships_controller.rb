class MembershipsController < ApplicationController
  before_action :set_membership, only: %i[show edit update]
  # before_action :set_membership_to_delete, only: %i[destroy]
  # GET /memberships or /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1 or /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beerclubs = Beerclub.all
    @memberships = Membership.all
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships or /memberships.json
  def create
    @membership = Membership.create params.require(:membership).permit(:user_id, :beerclub_id)
    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        format.html { redirect_to beerclub_path(@membership.beerclub_id), notice: "#{current_user.username} welcome to the club." }
        format.json { render :show, status: :created, location: @membership }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1 or /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: "Membership was successfully updated." }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1 or /memberships/1.json
  def destroy
    # binding.pry
    beerclub_id = params[:membership]["beerclub_id"]
    user_id = params[:membership]["user_id"]
    @membership_todel = Membership.find_by(beerclub_id: beerclub_id, user_id: user_id)
    # puts params[:membership]

    @membership_todel.destroy!
    respond_to do |format|
      format.html { redirect_to beerclub_path(beerclub_id), status: :see_other, notice: "#{current_user.username} successfully left the club." }
      format.json { head :no_content }
    end
  end

  private

  def set_membership_to_delete
    @membership_todel = Membership.find_by(beerclub_id: params[:beerclub_id], user_id: params[:user_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.expect(membership: [:user_id, :beerclub_id])
  end
end
