def relative path
  File.join(File.expand_path(File.dirname(__FILE__)), path)
end
require relative('app/models/user.rb')
require relative('app/models/text.rb')

include Models

tom = User.new("Tom", "abc")
tom.save
Text.new("Humpty Dumpty", "Humpty Dumpty sat on the wall...", tom).save
