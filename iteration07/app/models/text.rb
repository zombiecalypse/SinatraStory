class Text
  attr_accessor :text, :title
  attr_reader :id, :user

  @@texts = []
  @@text_count = 0

  def initialize( title, text, user )
    self.text = text
    self.title = title
    @user = user
    @id = @@text_count
    @image_paths = []
    @@text_count += 1
  end

  def save
    @@texts << self unless @@texts.include? self
  end

  def image_paths
    @image_paths.dup
  end

  def add_image_path path
    @image_paths << path
  end

  def editable? user
    user == self.user
  end


  def delete
    @@texts.delete self
    user.remove_text self.id
  end

  def self.all
    @@texts
  end

  def self.by_id id
    @@texts.detect {|txt| txt.id == id}
  end

  def self.reset
    @@texts = []
    @@text_count = 0
  end
end
