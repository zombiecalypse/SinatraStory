require 'rubygems'
require 'bcrypt'

module Models
  class User
    attr_reader :name, :password_hash, :password_salt

    @@users = {}

    def initialize(name, password)
      # Promise me to never store a password in clear text in your
      # database!
      # BCrypt is good *because* it is slow, making it hard to crack
      # by brute force.
      pw_salt = BCrypt::Engine.generate_salt
      pw_hash = BCrypt::Engine.hash_secret(password, pw_salt)
      @name = name
      @password_hash = pw_hash
      @password_salt = pw_salt

      @texts = {}
    end

    def texts
      @texts.values
    end

    def add_text( title, text )
      new_text = Text.new(title, text, self)
      @texts[new_text.id] = new_text
      new_text.save
      new_text
    end

    def remove_text( id )
      @texts.delete(id)

      throw "something weird happened" if @texts[id]
    end

    def save
      raise "Duplicated user" if @@users.has_key? name and @@users[name] != self

      @@users[name] = self
    end

    def self.available? name
      not @@users.has_key? name
    end

    def self.by_name name
      @@users[name]
    end

    def self.login name, password
      user = @@users[name]

      return false if user.nil?

      user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
    end

    def self.all
      @@users.values
    end

    def self.reset
      @@users = {}
    end
  end
end
