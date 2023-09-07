class Api::V1::ChefsController < ApplicationController
  def index
    @chefs = User.by_type_chef
  end

  def show
    @chef = User.find(params[:id])
  end
end
