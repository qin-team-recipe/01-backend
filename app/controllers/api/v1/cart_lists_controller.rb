class Api::V1::CartListsController < Api::V1::ApplicationBaseController
  before_action :set_user

  def index
    @cart_lists = @user.cart_lists.preload(:cart_items)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
