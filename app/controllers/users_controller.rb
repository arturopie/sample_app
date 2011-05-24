class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]
  before_filter :signed_in_user, :only => [:new, :create]

  def destroy
    user = User.find( params[:id] )
    if user.admin?
      flash[:error] = "Admin users cannot be destroyed."
    else
      user.destroy
      flash[:success] = "User destroyed."
    end
      redirect_to users_path
  end

  def new
    @user = User.new
    @title = "Sign up"
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])

  end

  def show
    @user = User.find params[:id]
    @microposts = @user.microposts.paginate :page => params[:page]
    @title = @user.name
  end

  def create
    @user = User.new params[:user]
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes params[:user]
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  private

  def correct_user
    @user = User.find params[:id]
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def signed_in_user
    redirect_to root_path if signed_in?
  end
end
