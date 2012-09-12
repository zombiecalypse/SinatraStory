require 'rubygems'
require 'sinatra'
require 'sinatra/outputbuffer'

get "/" do
  haml :index
end

post "/greet" do
  haml :greet, :locals => {:greetee => params[:greetee]}
end
