def relative(path)
  File.join(File.expand_path(File.dirname(__FILE__)), path)
end
Views = relative('app/views')
