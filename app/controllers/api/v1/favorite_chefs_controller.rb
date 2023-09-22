class Api::V1::FavoriteChefsController < Api::V1::ApplicationBaseController
  before_action :set_user
  before_action :set_chef

  def create
    @user.follow!(@chef)
  rescue ArgumentError
    render json: { error: 'Error during the create operation' }, status: :unprocessable_entity
  end

  def destroy
    @user.unfollow!(@chef)
  rescue ArgumentError
    render json: { error: 'Error during the destroy operation' }, status: :unprocessable_entity
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_chef
    @chef = User.find(params[:chef_id])
  end
end
