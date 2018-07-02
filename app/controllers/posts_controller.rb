class PostsController < ApplicationController
  before_action :get_category
  before_action :find_post, only: [:destroy, :edit, :update]
  before_action :post_owner, only: [:destroy, :edit, :update]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      redirect_to @post
    else
      render :new
    end
  end

  def show
    @post = Post.find_by id: params[:id]
    if @post.nil?
      flash[:danger] = t(".show_not_found")
      redirect_to root_url
    else
      increment_view
    end

    @posts = Post.load_info_post_new.all_except(params[:id]).limit(Settings.post_limit_8).order("view DESC")
    @comments = Comment.where(post_id: @post).order("created_at DESC")
  end

  def destroy
    if @post.destroy
      redirect_to root_url
    else
      redirect_to post_path(@post)
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      redirect_to edit_post_path
    end
  end

  private

  def post_params
    params.require(:post).permit :title, :content, :original_name, :year, :magnet_link, :subscene, :directors, :cast, :image, :time, :nation, :link_trailer, category_ids: []
  end

  def get_category
    @category = Category.load_name_category
  end

  def increment_view
    session_id = request.session_options[:id]
    is_increment = false

    if session_id.present?
      session[:view_post] = {} unless session[:view_post]

      if (session_id != session[:view_post]["post_id_#{@post.id}"])
        is_increment = true
        session[:view_post]["post_id_#{@post.id}"] = session_id
      end
    else
      is_increment = true
    end

    @post.increment!(:view) if is_increment
  end

  def find_post
    @post = Post.find_by(id: params[:id])
    return if @post
    redirect_to root_url
  end

  def post_owner
    unless current_user.id == @post.user_id
      flash[:notice] = t("you_can_not_do_that")
      redirect_to @post
    end
  end
end
