class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show create new)
  before_action :load_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :is_admin?, only: :destroy

  def show
    @microposts = @user.microposts.order_desc.paginate page: params[:page],
      per_page: Settings.perpage
  end

  def new
    @user = User.new
  end

  def index
    @users = User.paginate page: params[:page], per_page: Settings.perpage
  end

  def create
    @user = User.new user_params # Not the final implementation!
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".info"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".update"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "flash_success"
    else
      flash[:danger] = t "flash_danger"
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t ".pl_login"
    redirect_to login_path
  end

  # Confirms the correct user.
  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def is_admin?
    redirect_to root_path unless current_user.admin?
  end
end
