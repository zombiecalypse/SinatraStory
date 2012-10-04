require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'sinatra/content_for'
require 'rdiscount'
require_relative('../models/user')
require_relative('../../config.rb')

include Models

module Controllers
  class Authentication < Sinatra::Base
    module Helpers
      def user
        User.by_name session[:username]
      end
    end
    helpers Sinatra::ContentFor
    helpers Helpers
    set :views, Views
    get "/signup" do
      haml :signup
    end

    post "/signup" do
      username, pw, pw2 = params[:username], params[:password], params[:password2]

      halt "Passwords not identical" if pw != pw2

      halt "User name not available" unless User.available? username

      User.new(username, pw).save

      session[:username] = username
      redirect "/"
    end

    post "/login" do
      halt 401, "No such login" unless User.login params[:username], params[:password]

      session[:username] = params[:username]

      redirect back
    end

    get "/logout" do
      session[:username] = nil
      redirect back
    end

  end
end
