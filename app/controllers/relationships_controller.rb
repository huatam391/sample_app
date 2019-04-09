class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_followed_id, only: :create
  before_action :load_relationship, only: :destroy

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = @relation.followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def load_followed_id
    @user = User.find_by id: params[:followed_id]
    return if @user
    flash[:danger] = t "controllers.relationships.not_exist"
    redirect_to root_path
  end

  def load_relationship
    @relation = Relationship.find_by id: params[:id]
    return if @relation
    flash[:danger] = t "controllers.relationships.not_followed"
    redirect_to root_path
  end
end
