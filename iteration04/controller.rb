require 'rubygems'
require 'sinatra'
require 'sinatra/outputbuffer'
require 'rdiscount'
require './models.rb'

tom = User.new("Tom", "abc")
tom.save
Text.new("Humpty Dumpty", "Humpty Dumpty sat on the wall...", tom).save

enable :sessions 

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

post "/text" do
				return 401 if @user.nil?

				text = @user.create_text(params[:title], params[:text])

				redirect to("/text/#{text.id}")
end

post "/text/:id" do
	text = Text.by_id(params[:id].to_i)
  
	return 404 if text.nil?
	return 401 unless text.editable? @user

  text.title, text.text = params[:title], params[:text]

	redirect to("/text/#{text.id}")
end

delete "/text/:id" do
	text = Text.by_id(params[:id].to_i)
  
	return 404 if text.nil?
	return 401 unless text.editable? @user
  
  text.delete

	redirect to("/text")
end

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

before do
				@user = User.by_name session[:username]
end
