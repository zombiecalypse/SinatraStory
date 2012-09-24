def relative(path)
  File.join(File.dirname(__FILE__), path)
end

require relative('controller.rb')

require 'rack/test'


include Rack::Test::Methods

describe User do
  context "Tom" do
    before(:all) do
      User.reset
      Text.reset
      @tom = User.new "Tom", "abc"
      @tom.save
    end

    it "can create texts" do
      text = @tom.add_text("Humpty", "Dumpty")
      text.user.should eq(@tom)
      @tom.texts.should eq([text])
    end

    it "can be found by his name" do
      @tom.should eq(User.by_name("Tom"))
    end

    it "can remove texts by id" do
      text = @tom.texts.first
      @tom.remove_text(text.id)
      @tom.texts.should eq([])
    end
  end

  context "Database" do
    before(:all) do
      User.reset
      Text.reset
      ["Tom", "Tina", "Talia"].each { |e| User.new(e, e.downcase).save }
    end

    it "can tell if a user can login" do
      User.login("Tom", "tina").should eq(false)
      User.login("Tom", "tom").should eq(true)
    end

    it "can list all users" do
      User.all.collect(&:name).should eq(["Tom", "Tina", "Talia"])
    end
  end
end

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
