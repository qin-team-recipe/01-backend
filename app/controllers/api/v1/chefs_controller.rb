class Api::V1::ChefsController < Api::V1::ApplicationBaseController
  def index
    @chefs = User.by_type_chef
  end

  def show
    @chef = User.find(params[:id])
  end

  def search
    keyword = params[:keyword]

    raise ActionController::ParameterMissing, 'keyword parameter is missing' if keyword.nil?

    page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @chefs = User.by_type_chef.order_by_name.search_by_name(keyword).paginate(page)
  end
end
