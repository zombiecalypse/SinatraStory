def relative(path)
  File.join(File.dirname(__FILE__), path)
end
require 'sinatra/base'

require relative('fixture.rb')
require relative('app/controllers/init.rb')


class Main < Sinatra::Base
  enable :sessions
  set :views, Views
  use Controllers::Authentication
  use Controllers::TextController

  get("/") { redirect to("/text") }
end

Main.run!
