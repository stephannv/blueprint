# Blueprint

Bluprint is a lib for writing HTML templates in plain Crystal, allowing an OOP (Oriented Object Programming) when building HTML.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     blueprint:
       github: stephannv/blueprint
   ```

2. Run `shards install`

## Usage

#### Basic usage

```crystal
require "blueprint"

class MyPage
  include Blueprint::HTML

  def blueprint
    doctype

    html do
      head do
        title { "My website" }

        link rel: "stylesheet", href: "app.css"
        script type: "text/javascript", src: "app.js"
      end

      body do
        p { "Hello" }
        div class: "bg-gray-200" do
          label(for: "email") { "Email" }
          input type: "text", id: "email"
        end
      end
    end
  end
end

page = MyPage.new
puts page.to_html
# <!DOCTYPE html>
#
# <html>
#   <head>
#     <title>My website</title>
#
#     <link rel="stylesheet" href="app.css">
#     <script type="text/javascript" src="app.js"></script>
#   </head>
#
#   <body>
#     <p>Hello</p>
#
#     <div class="bg-gray-200">
#       <label for="email">Email</label>
#       <input type="text" id="email">
#     </div>
#   </body>
# </html>
```

#### Composing with multiple blueprints 

```crystal
require "blueprint"

class FooterComponent
  include Blueprint::HTML
  
  def blueprint
    footer do
      ul do
        li { "Home" }
        li { "About" }
        li { "Contact" }
      end
    end
  end
end

class HomePage
  include Blueprint::HTML
  
  def blueprint
    div do
      render FooterComponent.new
    end
  end
end
  
page = HomePage.new
puts page.to_html
# <div>
#   <footer>
#     <ul>
#       <li>Home</li>
#       <li>About</li>
#       <li>Contact</li>
#     </ul>
#   </footer>
# </div>
```

#### Passing content to another blueprint

```crystal
require "blueprint"

class CalloutComponent
  include Blueprint::HTML

  def blueprint(&)
    div class: "bg-green-400 p-4 border shadow" do
      yield
    end
  end
end

class HomePage
  include Blueprint::HTML

  def blueprint
    render CalloutComponent.new do
      "Nice message here"
    end
  end
end

page = HomePage.new
puts page.to_html
# <div class="bg-green-400 p-4 border shadow">
#   Nice message here
# </div>

```

#### Building complex blueprints

```crystal
require "blueprint"

class CardComponent
  include Blueprint::HTML

  def blueprint(&)
    div class: "flex flex-col gap-2 bg-white border shadow" do
      yield
    end
  end

  def header(&)
    div class: "p-2 text-lg font-bold" do
      yield
    end
  end

  def body(&)
    div class: "p-4" do
      yield
    end
  end
end

class HomePage
  include Blueprint::HTML

  def blueprint
    render CardComponent.new do |c|
      c.header { "Card title" }
      c.body do
        span { "Card body" }
        a(href: "/about") { "See more" }
      end
    end
  end
end

page = HomePage.new
puts page.to_html
# <div class="flex flex-col gap-2 bg-white border shadow">
#   <div class="p-2 text-lg font-bold">
#     Card title
#   </div>
#   
#   <div class="p-4">
#     <span>Card body</span>
#     <a href="/about">See more</a>
#   </div>
# </div>
```

#### Blueprints are just POCO (Plain old crystal objects)

You can define an initializer with argurments needed to render that blueprint

```crystal
require "blueprint"

require "./src/blueprint"

class Button
  include Blueprint::HTML

  enum Color
    Red
    Green
    Blue
  end

  def initialize(@color : Color); end

  def blueprint(&)
    div class: classes do
      yield
    end
  end

  private def classes
    case @color
    when .red? then "bg-red-500"
    when .green? then "bg-green-600"
    when .blue? then "bg-blue-400"
    end
  end
end

class HomePage
  include Blueprint::HTML

  def blueprint
    render Button.new(color: Button::Color::Red) do
      "Destroy"
    end
  end
end

page = HomePage.new
puts page.to_html
# <div class="bg-red-500">Destroy</div>
```

#### Using `data-*` attributes

```crystal
require "blueprint"

class Tab
  include Blueprint::HTML

  def blueprint
    a(data: { target: "#home", active: true }) { "Home" }
  end
end

tab = Tab.new
puts tab.to_html
# <a data-target="#home" data-active="true">
#   Home
# </a>

```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/stephannv/blueprint/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Stephann V.](https://github.com/stephannv) - creator and maintainer
