class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      user_activated_or_not @user
    else
      flash.now[:danger] = t ".invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def load_user
    @user = User.find_by email: params[:session][:email].downcase
  end

  def user_activated_or_not user
    if user.activated?
      log_in user
      if params[:session][:remember_me] == Settings.one
        remember(user)
      else
        forget(user)
      end
      redirect_back_or user
    else
      message = t ".mess"
      flash[:warning] = message
      redirect_to root_path
    end
  end
end
