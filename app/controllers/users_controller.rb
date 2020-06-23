# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @flavors = current_user.flavors.order(id: 'ASC').page(params[:page]).per(5)
  end

  def image
    @flavors = current_user.flavors
  end
end
