class UsersController < ApplicationController
  before_action :check_logged_in, only: [:edit, :update, :index]
  before_action :check_correct_user, only: [:edit, :update]
  
  def index
    @users = User.all
  end
  
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
      remember @user
      flash[:success] = "Welcome to Trust!"
      redirect_to @user
  	else
  		render :new
  	end
  end
  
  def edit
    @user = User.find(params[:id])
    flash[:info] = "Leave password blank if you don't want to change."
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.username}'s prifile updated successfully."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  
  	def user_params
  		params.require(:user).permit(:username, :email, :password, :password_confirmation)
  	end
    
    # Before filters
    
    # Confirms a logged-in user.
    def check_logged_in
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # Confirms the correct user.
    def check_correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
