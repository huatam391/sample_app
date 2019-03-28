class UsersController < ApplicationController
  before_action :load_user, only: [:show]
  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params # Not the final implementation!
    if @user.save
      flash[:success] = t("controllers.users_controller.flash-message")
      redirect_to @user
    else
      render :new
    end
  end

  private

  def load_user
    @user = User.find_by(id: params[:id])
      return unless @user.nil?
      flash[:danger] = t("controllers.users_controller.usernotEX")
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
