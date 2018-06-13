class RelationshipsController < ApplicationController
  def create
    @user = User.find params[:followed_id]
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to "/", notice: t(".addfriend_success")}
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to "/", notice: t(".unfriend_success")}
      format.js
    end
  end
end
