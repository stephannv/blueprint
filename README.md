# Blueprint

TODO: Write a description here

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     blueprint:
       github: stephannv/blueprint
   ```

2. Run `shards install`

## Usage

```crystal
require "blueprint"

class MyPage
  include Blueprint::HTML

  def blueprint
    html do
      head do
        title { "My website" }

        link rel: "stylesheet", href: "app.css"
        script type: "text/javascript", src: "app.js"
      end

      body do
        div class: "bg-gray-200" do
          label(for: "email") { "Email" }
          input type: "text", id: "email"
        end
      end
    end
  end
end

page = MyPage.new
html = page.call
puts html
# <html>
#   <head>
#     <title>My website</title>
#
#     <link rel="stylesheet" href="app.css">
#     <script type="text/javascript" src="app.js"></script>
#   </head>
#
#   <body>
#     <div class="bg-gray-200">
#       <label for="email">Email</label>
#       <input type="text" id="email">
#     </div>
#   </body>
# </html>
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
