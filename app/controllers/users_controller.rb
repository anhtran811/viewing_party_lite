class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end
  
  def discover_movies
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    user = User.new(name: params[:name], email: params[:email])
    if user.save(user_params)
      flash.notice = 'User has been created!'
      redirect_to user_path(user)
    else
      flash.alert = 'Cannot use existing email'
      redirect_to register_path
    end
  end
  
  private
    def user_params
      params.permit(:name, :email)
    end
end