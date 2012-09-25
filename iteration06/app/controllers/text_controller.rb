def relative(path)
  File.join(File.dirname(__FILE__), path)
end

require 'rubygems'
require 'sinatra/base'
require 'sinatra/content_for'
require 'haml'
require 'rdiscount'
require relative('../models/user')
require relative('../models/text')
require relative('../../fixture.rb')
require relative('authentication')

include Models
module Controllers
  class TextController < Sinatra::Base
    helpers Sinatra::ContentFor
    helpers Authentication::Helpers
    set :views, Views

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

      text = @user.add_text(params[:title], params[:text])

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
  end
end
