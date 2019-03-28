class SessionsController < ApplicationController
  before_action :load_user, only: :create

  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user"s show page.
      log_in @user
      params[:session][:remember_me] == t(".remember_me") ? remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger] = t ".mess"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def load_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end
end
