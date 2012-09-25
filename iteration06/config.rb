def relative(path)
  File.join(File.dirname(__FILE__), path)
end
Views = relative('app/views')
