class Api::V1::ChefsController < ApplicationController

  def index
    @chefs = User.chef_users
  end
end
