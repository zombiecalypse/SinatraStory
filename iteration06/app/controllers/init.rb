def relative(path)
  File.join(File.dirname(__FILE__), path)
end

require_relative 'authentication.rb'
require_relative 'text_controller.rb'
