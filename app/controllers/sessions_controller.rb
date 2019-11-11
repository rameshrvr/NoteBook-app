class SessionsController < ApplicationController

  def index
  end

  def new
  end

  def create
    user = UserProfile.find_by_email(params[:email])
    puts "User: #{user}"
    if user && user.authenticate(params[:password])
    	puts "Inside if block"
      session[:user_id] = user.id
      redirect_to "/notes", notice: "Logged in!"
    else
    	puts "Inside else block"
      redirect_to "/sessions", notice: "Email or password is invalid"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end
