def relative(path)
  File.join(File.expand_path(File.dirname(__FILE__)), path)
end

require 'rubygems'
require 'sinatra/base'
require 'sinatra/content_for'
require 'haml'
require 'rdiscount'
require_relative('../models/user')
require_relative('../models/text')
require_relative('../../fixture.rb')
require_relative('authentication')

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

    get "/text/:id/" do
      text = Text.by_id(params[:id].to_i)

      return 404 if text.nil?

      haml :show, :locals => {:text => text}
    end

    post "/text" do
      return 401 if user.nil?

      text = user.add_text(params[:title], params[:text])

      redirect to("/text/#{text.id}/")
    end

    post "/text/:id/" do
      text = Text.by_id(params[:id].to_i)

      return 404 if text.nil?
      return 401 unless text.editable? user

      text.title, text.text = params[:title], params[:text]

      redirect "/text/#{text.id}/"
    end

    delete "/text/:id/" do
      text = Text.by_id(params[:id].to_i)

      return 404 if text.nil?
      return 401 unless text.editable? user

      text.delete

      redirect to("/text")
    end

    def id_image_to_filename(id, path)
      "#{id}_#{path}"
    end

    post "/text/:id/images" do
      text = Text.by_id(params[:id].to_i)
      return 404 unless text
      return 401 unless text.editable? user
      file = params[:file_upload]
      return 404 unless file
      return 413 if file[:tempfile].size > 400*1024

      filename = id_image_to_filename(text.id, file[:filename])

      FileUtils::cp(file[:tempfile].path, File.join("public", "images", filename))

      redirect to("/text/#{params[:id]}/")
    end

    get "/text/:id/images/:pic" do
      send_file(File.join("public","images", id_image_to_filename(params[:id], params[:pic])))
    end
  end
end
