def relative(path)
  File.join(File.dirname(__FILE__), path)
end

require relative('../app/controller/text_controller.rb')

require 'rack/test'


include Rack::Test::Methods
include Controllers

describe "Server" do
  before(:each) do
    User.reset
    Text.reset
    @tom = User.new("Tom", "tom")
    @tom.save
    @text = @tom.add_text("Humpty", "Dumpty")
  end
  after(:all) do
    User.reset
    Text.reset
  end

  def app
    Sinatra::Application
  end

  context "for unregistered users" do
    it "lists all text titles under /text" do
      get "/text"
      last_response.body.should include("Humpty")
      last_response.body.should_not include("Dumpty")
    end

    it "can show the full text under /text/:id" do
      get "/text/#{@text.id}"

      last_response.body.should include("Humpty")
      last_response.body.should include("Dumpty")
    end
  end

  context "for registered users" do
    before(:all) do
      post "/login", :username => "Tom", :password => "tom"
    end

    it "accepts posts to /text as new text" do
      post "/text", :title => "The Cat", :text => "The cat sat on the mat"

      last_response.status.should == 302
      Text.all.collect(&:title).should include("The Cat")
    end

    it "deletes posts on /text/:id" do
      delete "/text/#{@text.id}"

      @tom.texts.should == []
    end

    it "updates posts on POST /text/:id" do
      post "/text/#{@text.id}", :title => "The Cat", :text => "The cat sat on the mat"

      @text.title.should == "The Cat"
    end
  end
end
