class Text
				attr_accessor :text, :title
				attr_reader :id

				@@texts = []
				@@text_count = 0

				def initialize( title, text )
								self.text = text
								self.title = title
								@id = @@text_count
								@@text_count += 1
				end

				def save
								@@texts << self unless @@texts.include? self
				end

				def delete
								@@texts.delete self
				end

				def self.all
								@@texts
				end

				def self.by_id id
								@@texts.detect {|txt| txt.id == id}
				end
end
