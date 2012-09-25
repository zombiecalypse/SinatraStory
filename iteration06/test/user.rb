def relative(path)
  File.join(File.dirname(__FILE__), path)
end

require relative('../app/models/user.rb')
require relative('../app/models/text.rb')
include Models

describe User do
  context "Tom" do
    before(:all) do
      User.reset
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
