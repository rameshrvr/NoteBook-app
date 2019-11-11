class SessionsController < ApplicationController

  def index
  end

  def new
  end

  def create
    user = UserProfile.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to "/notes", notice: "Logged in!"
    else
      redirect_to "/sessions", notice: "Email or password is invalid"
    end
  end

  def destroy
    session[:user_id] = nil
    puts "Inside destroy"
    redirect_to root_url, notice: "Logged out!"
  end

  def logout_user
  	session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
