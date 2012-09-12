require 'rubygems'
require 'sinatra'
require 'sinatra/outputbuffer'

get "/" do
				haml :index
end

post "/greet" do
				haml :greet, locals: {greeter:params[:greeter]}
end
