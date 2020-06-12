require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :home
  end

  get "/signup" do
    erb :'/users/signup'
  end

  post "/signup" do
    #binding.pry
    user = User.new(:email=> params[:email], :password=> params[:password], :username=> params[:username])
    if user.save && user.email != nil && user.username !=nil
      redirect '/tweets'
    else
      redirect '/failure'
    end
  end

  get "/login" do
    erb :'/users/login'
  end

  post "/login" do
    user = User.find_by(:username=>params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    # else
    #   redirect "/failure"
    end
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
        User.find(session[:user_id])
    end
  end
end
