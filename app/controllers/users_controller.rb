class UsersController < ApplicationController
  before_action :load_user, except: :index

  def show
    @posts = @user.posts.load_info_new.order("created_at DESC")
  end

  def index
    @users = User.all
  end

  def following
    @title = "Following"
    @users = @user.following.paginate page: params[:page]
    render 'show_friends'
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate page: params[:page]
    render 'show_friends'
  end

  def friends
    @title = "Friends"
    @users = @user.friends.paginate page: params[:page]
    render 'show_friends'
  end

  private

  def load_user
    @user  = User.find_by id: params[:id]
    redirect_to users_path unless @user
  end
end
