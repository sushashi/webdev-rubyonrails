class SessionsController < ApplicationController
  def new
    # render the signing up page
  end

  def create
    # retrieves from the database the user that matches the username
    user = User.find_by username: params[:username]
    # saves the user ID who signed up (if the user exists) and check password
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome Back!"
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # resets the session
    session[:user_id] = nil
    # redirects the application to the main page
    redirect_to :root
  end
end
