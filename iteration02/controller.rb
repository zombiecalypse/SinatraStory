require 'rubygems'
require 'sinatra'
require 'sinatra/outputbuffer'
require 'rdiscount'
require './models.rb'

Text.new("Humpty Dumpty", "Humpty Dumpty sat on the wall...").save

get "/" do
  haml :index, :locals => {:texts => Text.all}
end

get "/text/:id" do
	text = Text.by_id(params[:id].to_i)

	return 404 if text.nil?

  haml :show, :locals => {:text => text}
end
