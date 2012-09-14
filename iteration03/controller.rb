require 'rubygems'
require 'sinatra'
require 'sinatra/outputbuffer'
require 'rdiscount'
require './models.rb'

Text.new("Humpty Dumpty", "Humpty Dumpty sat on the wall...").save

get("/") { redirect to("/text") }

get "/text/new" do
	haml :new
end

get "/text/:id/edit" do
	@text = Text.by_id(params[:id].to_i)

	haml :edit
end

get "/text" do
  haml :index, :locals => {:texts => Text.all}
end

get "/text/:id" do
	text = Text.by_id(params[:id].to_i)

	return 404 if text.nil?

  haml :show, :locals => {:text => text}
end

put "/text" do
				text = Text.new(params[:title], params[:text])
				text.save
				redirect to("/text/#{text.id}")
end

post "/text/:id" do
	text = Text.by_id(params[:id].to_i)
  
	return 404 if text.nil?

  text.title, text.text = params[:title], params[:text]
end

delete "/text/:id" do
	text = Text.by_id(params[:id].to_i)
  
	return 404 if text.nil?
  
  text.delete

	redirect to("/text")
end

