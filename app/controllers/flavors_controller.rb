# frozen_string_literal: true

class FlavorsController < ApplicationController
  before_action :authenticate_user!
  def index
    @flavors = Flavor.where(id: 2..25).order(id: 'ASC').page(params[:page]).per(10)
    @status_image = ['', 'urn_red.png', 'urn_yellow.png', 'urn_blue.png']
  end

  def new
    @flavor = Flavor.new
  end

  def create
    @flavor = Flavor.new(flavor_params)
    @flavor.save
    redirect_to flavors_path
  end

  def edit
    @flavor = Flavor.find(params[:id])
    render 'edit.js.erb'
  end

  def update
    @flavor = Flavor.find(params[:id])
    @flavor.update(flavor_params)
    if @flavor.status == 1
      @flavors_1 = Flavor.where(status: 1)
      @users = User.all
      user_ids = @users.map(&:id)
      flavor_ids = @flavors_1.map(&:id)
      FlavorMailer.send_status_1(user_ids, flavor_ids).deliver_later
    end
    @flavors = Flavor.all.order(id: 'ASC').page(params[:page]).per(10)
    redirect_to flavors_path
  end

  def search
    @flavors = Flavor.search(params[:search])
    @status_image = ['', 'urn_red.png', 'urn_yellow.png', 'urn_blue.png']
  end

  private

  def flavor_params
    params.require(:flavor).permit(:name, :purchase_price, :image, :image_cache, :status).merge(user_id: current_user.id)
  end
end
