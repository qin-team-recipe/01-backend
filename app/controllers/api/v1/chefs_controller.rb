class Api::V1::ChefsController < ApplicationController
  def index
    @chefs = User.by_type_chef
  end
end
