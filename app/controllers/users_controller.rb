class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :delete]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:index,:destroy]
  def new
    if signed_in?
      redirect_to(root_url)
    else
      @user=User.new
    end
  end
  
  def show
    if signed_in? && User.find_by(id: params[:id])
      if current_user?(User.find(params[:id])) || current_user.admin?
        @user=User.find(params[:id])
      else
        redirect_to(root_url)
      end
    else
      redirect_to(root_url)
    end
  end
  
  def create
    if signed_in?
      redirect_to(root_url)
    else
      @user = User.new(user_params)    
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        render 'new'
      end
    end
  end
  
  def edit
    if User.find_by(id: params[:id])
      @user = User.find(params[:id])
    else
      redirect_to(root_url)
    end
  end
  
  def index
    if signed_in?
      @users = User.paginate(page: params[:page])
    else
      redirect_to(root_url)
    end
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # Before filters

    def signed_in_user
      store_location
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end
    
    def correct_user
      if User.find_by(id: params[:id])
        @user = User.find(params[:id])
      end
        redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      if signed_in?
        redirect_to(root_url) unless current_user.admin?
      end
    end
end
