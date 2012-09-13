SinatraStory
============

Hi there! In this tutorial, I'll show you how you can build web apps in the
ruby [Sinatra](http://www.sinatrarb.com/) framework. As web frameworks go,
Sinatra is a very simplistic one, as opposed to for example [Rails](http://rubyonrails.org/)
which is huge, does everything for you and leaves you with a feeling of not
knowing, what the heck is going on. I'm not saying that that is necessarily
bad, if you accept it, it allows for very fast development. Sinatra on the
other hand gives the developer much more freedom and actually feels more like
a nice library than a framework. 

The canonical `hello world` example uses only a single file and goes like
this:

```ruby
# hello.rb
require 'rubygems'
require 'sinatra'

get "/" do
  "Hello World"
end
```

if you run it with `ruby hello.rb` and head to
[localhost:4567](http://localhost:4567), you get the rewarding "Hello World".

But you wouldn't call that a web application yet. In the first step, let us
figure out, how to write html. If we were really hardcore, we could just write
it into the return value of our method:

```ruby
# hello2.rb
require 'rubygems'
require 'sinatra'

get "/" do
  "<h1>Hello World</h1>"
end
```

but who does that? Nobody, that's who! Well, at least not a software aesthete
as myself. I personally prefer [HAML](http://haml.info), which translates directly
into HTML, but removes all the boilerplate. Fortunately, it is really easy to
use with Sinatra:

```ruby
# hello2.rb
require 'rubygems'
require 'sinatra'
require 'haml'

get "/" do
  haml "%h1 Hello World"
end
```

because `haml` just converts the string into HTML and returns that. If you
know the [MVC](http://en.wikipedia.org/wiki/Model_View_Controller) pattern,
you should recognize, that Sinatra provides the *controller* part, so it
should grab some *model* parts and redirect them to the *view*. Ok,
admittedly, we don't need a model at this point, but it would be nice to
separate the controller part from the view part, so we should move the HAML
code to a separate file:

```haml
# views/hello3.haml
%h1 Hello World
```

```ruby
# hello3.rb
require 'rubygems'
require 'sinatra'
require 'haml'

get "/" do
  haml :hello3
end
```

Sinatra will look for the "views" folder and find the matching file.

Now we can start adding some actual fuctionality to it: The Hello World is a
bit unpersonal, so lets add that: First of all, we need a form, in which we
ask the user for their name and then direct to a page in which displays the
Hello User page.

For this, you need to know, that HTTP has `GET` and `POST` commands, the
latter of which pushes new information onto the server. That kind of reflects,
what we want, so we add a new route:

```ruby
post "/greet" do
  # ...
end
```

In that route, we want to display the Hello User, so the HAML will look like

```haml
# views/greet.haml
%h1 
  Hello
  = greetee
```

The `=` tells haml to evaluate the `greetee` and display it. Now we only need
to define the `greetee` variable in this context:

```ruby
# routes.rb
post "/greet" do
  haml :greet, :locals => { :greetee => params[:greetee] }
end
```

The `params` variable, as you might have guessed, gives a dictionary of the
parameters, that were sent to the server in this request. `locals` defines,
what variables can be used in the HAML file.

Now we need a form that queries the name:

```ruby
# routes.rb 
get "/" do
  haml :index
end
```

```haml
# views/index.haml
%form(action = "/greet" method="POST")
  %label 
    Name:
    %input(type='text' name = 'greetee' value='world')
  %input(type='submit')
```

This form gives a single text field, that is sent back under the name of
`:greetee` and `POST`s it to the "/greet" URL. As you can see, it is very
straight forward what is happening.

Now, when you run it and go to the [localhost:4567](http://localhost:4567), you get a
form, and if you enter "Tim" into the form field, the greeting will be "Hello
Tim" instead of "Hello World".

That is enough for the first iteration, the next time, I'll show you, how you
can use a model too. Hint: It is just plain ruby.
