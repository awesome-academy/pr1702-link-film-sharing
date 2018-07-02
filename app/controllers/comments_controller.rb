class CommentsController < ApplicationController
  before_action :find_post
  before_action :find_comment, only: [:destroy, :edit, :update]
  before_action :comment_owner, only: [:destroy, :edit, :update]

  def create
    @comment = @post.comments.create(comment_params)
    @comment.user_id = current_user.id
    @comment.save

    respond_to do |format|
      format.js
    end
  end

  def destroy
    if @comment.destroy
      respond_to do |format|
        format.js
      end
    else
      redirect_to @comment.post
    end
  end

  def edit
  end

  def update
    @comment.update comment_params
    respond_to do |format|
      format.js
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def find_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_owner
    unless current_user.id == @comment.user_id
      flash[:notice] = t("you_can_not_do_that")
      redirect_to @post
    end
  end

  def comment_params
    params[:comment].permit(:content)
  end
end
