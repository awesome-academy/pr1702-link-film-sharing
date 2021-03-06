class CategoriesController < ApplicationController
  before_action :load_category, only: :show

  def index; end

  def show
    @posts = @category.posts.paginate page: params[:page], per_page: 12
  end

  private
  def load_category
    @category = Category.find_by id: params[:id]
    return if @category
    flash[:danger] = t('category_not_found')
  end
end
