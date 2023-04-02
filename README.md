> **Warning**
>
> This is the documentation for the in-development branch of Blueprint. You can find the documentation for previous releases on [tags](https://github.com/stephannv/blueprint/tags).

# Blueprint

Blueprint is a lib for writing fast, reusable and testable HTML templates in plain Crystal, allowing an OOP (Oriented Object Programming) approach when building web views.

```crystal
class MyForm
  include Blueprint::HTML

  private def blueprint
    div class: "mb-3" do
      label(for: "password") { "Password" }
      input type: "password", id: "password"
    end
  end
end
```

Output:

```html
<div class="mb-3">
  <label for="password">Password</label>
  <input type="password" id="password">
</div>
```

* [Instalation](#installation)
* [Changelog](#changelog)
* [Usage](#usage)
  * [Basic](#basic)
  * [Blueprints are just POCOs](#blueprints-are-just-pocos)
  * [Creating components](#creating-components)
  * [Passing content](#passing-content)
  * [Composing components](#composing-components)
  * [Conditional rendering](#conditional-rendering)
  * [NamedTuple attributes](#namedtuple-attributes)
  * [Boolean attributes](#boolean-attributes)
  * [Utils](#utils)
  * [Safety](#safety)
  * [Custom tags](#custom-tags)
  * [Registering components helpers](#registering-components-helpers)



## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     blueprint:
       github: stephannv/blueprint
   ```

2. Run `shards install`

## Changelog

Changelog can be found [here](/CHANGELOG.md)
## Usage

### Basic

You need three things to start using blueprint:

- Require `"blueprint/html"`
- Include `Blueprint::HTML` module in your class
- Define a `blueprint` method to write an HTML structure inside.

```crystal
require "blueprint/html"

class ExamplePage
  include Blueprint::HTML

  private def blueprint
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
```

With your class defined, you can instantiate it and call `to_html` and get the result.

```crystal
page = ExamplePage.new
puts page.to_html
```

The output (this HTML output is formatted to improve the visualization):

```html
<!DOCTYPE html>

<html>
  <head>
    <title>My website</title>

    <link rel="stylesheet" href="app.css">
    <script type="text/javascript" src="app.js"></script>
  </head>

  <body>
    <p>Hello</p>

    <div class="bg-gray-200">
      <label for="email">Email</label>
      <input type="text" id="email">
    </div>
  </body>
</html>
```

### Blueprints are just POCOs

Bluprints are Plain Old Crystal Objects (**POCOs**). You can add any behavior to your class just like a normal Crystal class.

```crystal
class Profiles::ShowPage
  include Blueprint::HTML

  def initialize(@user : User); end

  private def blueprint
    h1 { @user.display_name }

    if moderator?
      span class: "bg-blue-500" do
        img src: "moderator-badge.png"
      end
    end
  end

  private def moderator?
    @user.role == "moderator"
  end
end

page = Profiles::ShowPage.new(user: moderator)
puts page.to_html
```

Output:

```html
<h1>Jane Doe</h1>
<span class="bg-blue-500">
  <img src="moderator-badge.png">
</span>
```

### Creating components

You can create reusable components using Blueprint, you just need to pass a component instance to the `#render` method.

```crystal
class AlertComponent
  include Blueprint::HTML

  def initialize(@content : String, @type : String); end

  private def blueprint
    div class: "alert alert-#{@type}", role: "alert" do
      @content
    end
  end
end

class ExamplePage
  include Blueprint::HTML

  private def blueprint
    h1 { "Hello" }
    render AlertComponent.new(content: "My alert", type: "primary")
  end
end

page = ExamplePage.new
puts page.to_html
```

Output:

```html
<h1>Hello</h1>
<div class="alert alert-primary" role="alert">
  My alert
</div>
```

### Passing content

Sometimes you need to pass a complex content that cannot be passed through a constructor parameter. To do this, the `blueprint` method needs to receive a block (`&`) and yield it. Refactoring the previous Alert component example:

```crystal
class AlertComponent
  include Blueprint::HTML

  def initialize(@type : String); end

  private def blueprint(&)
    div class: "alert alert-#{@type}", role: "alert" do
      yield
    end
  end
end

class ExamplePage
  include Blueprint::HTML

  private def blueprint
    h1 { "Hello" }
    render AlertComponent.new(type: "primary") do
      h4(class: "alert-heading") { "My Alert" }
      p { "Alert body" }
    end
  end
end

page = ExamplePage.new
puts page.to_html
```

Output:

```html
<h1>Hello</h1>
<div class="alert alert-primary" role="alert">
  <h4 class="alert-heading">My alert</h4>
  <p>Alert body</p>
</div>
```

### Composing components

Blueprints components can expose some predefined structure to its users. This can be accomplished by defining public instance methods that accept blocks. Refactoring the previous Alert component example:

```crystal
class AlertComponent
  include Blueprint::HTML

  def initialize(@type : String); end

  private def blueprint(&)
    div class: "alert alert-#{@type}", role: "alert" do
      yield
    end
  end

  def title(&)
    h4(class: "alert-heading") { yield }
  end

  def body(&)
    p { yield }
  end
end

class ExamplePage
  include Blueprint::HTML

  private def blueprint
    h1 { "Hello" }
    render AlertComponent.new(type: "primary") do |alert|
      alert.title { "My Alert" }
      alert.body { "Alert body" }
    end
  end
end

page = ExamplePage.new
puts page.to_html
```

Output:

```html
<h1>Hello</h1>
<div class="alert alert-primary" role="alert">
  <h4 class="alert-heading">My alert</h4>
  <p>Alert body</p>
</div>
```

### Conditional rendering

Blueprints can implement a `#render?` method, if this method returns false, the blueprint will not be rendered. This allows you extract the logic from component consumer and put in the component itself.

Instead writing this code:
```crystal
class ArticlePage
  include Blueprint::HTML

  def initialize(@article: Article); end

  private def blueprint
    if @article.draft?
      render DraftArticleAlert.new(@article)
    end
    h1 { @article.title }
  end
end
```

You can write this code:

```crystal
class ArticlePage
  include Blueprint::HTML

  def initialize(@article: Article); end

  private def blueprint
    render DraftArticleAlert.new(@article)
    h1 { @article.title }
  end
end

class DraftArticleAlert
  include Blueprint::HTML

  def initialize(@article : Article); end

  private def blueprint
    div class: "alert alert-warning" do
      plain "This is a draft. "
    end
  end

  def render?
    @article.draft?
  end
end

article = Article.new(title: "Hello Blueprint", draft: false)
page = ArticlePage.new(article: article)
puts page.to_html
```

Output:

```html
<h1>Hello Blueprint</h1>
```

### NamedTuple attributes

If you pass a NamedTuple attribute to some element, it will be flattened with a dash between each level. This is useful for `data-*` and `aria-*` attributes.

```crystal
class ExamplePage
  include Blueprint::HTML

  private def blueprint
    div data: { id: 42, target: "#home" }, aria: { selected: "true" } do
      "Home"
    end
  end
end

page = ExamplePage.new
puts page.to_html
```

Output:

```html
<div data-id="42" data-target="#home" aria-selected="true">
  Home
</div>
```

### Boolean attributes

If you pass `true` to some attribute, it will be rendered as a boolean HTML attribute, in other words, just the attribute name will be rendered without the value. If you pass `false` the attribute will not be rendered. If you want the attribute value to be `"true"` or `"false"`, use `true` and `false` between quotes.

```crystal
class ExamplePage
  include Blueprint::HTML

  private def blueprint
    div required: true, disabled: false, x: "true", y: "false" do
      "Boolean"
    end
  end
end

page = ExamplePage.new
puts page.to_html
```

Output:

```html
<div required x="true" y="false">
  Boolean
</div>
```

### Utils

You can use the `#plain` helper to write plain text on HTML and the `#whitespace` helper to add a simple whitespace. The `#comment` allows you to write HTML comments.

```crystal
class ExamplePage
  include Blueprint::HTML

  private def blueprint
    comment { "This is an HTML comment" }

    h1 do
      plain "Hello"
      whitespace
      strong { "Jane Doe" }
    end
  end
end

page = ExamplePage.new
puts page.to_html
```

Output:

```html
<!--This is an HTML comment-->

<h1>
  Hello <strong>Jane Doe</strong>
</h1>
```

### Safety

All content and attribute values passed to elements and components are escaped:

```crystal
class ExamplePage
  include Blueprint::HTML

  private def blueprint
    span { "<script>alert('hello')</script>" }

    input(class: "some-class\" onblur=\"alert('Attribute')")
  end
end

page = ExamplePage.new
puts page.to_html
```

Output:

```html
<span>&lt;script&gt;alert(&#39;hello&#39;)&lt;/script&gt;</span>

<input class="some-class&quot; onblur=&quot;alert(&#39;Attribute&#39;)">
```

### Custom tags

You can register custom HTML tags using the `register_element` macro. The first argument is the helper method and the second argument is an optional tag name.

```crystal
class ExamplePage
  include Blueprint::HTML

  register_element :trix_editor
  register_element :my_button, "v-btn"

  private def blueprint
    trix_editor

    my_button(to: "#home") { "My button" }
  end
end

page = ExamplePage.new
puts page.to_html
```

Output:

```html
<trix-editor></trix-editor>

<v-btn to="#home">My button</v-btn>
```

### Registering components helpers

Blueprint has the `register_component` macro. It is useful to avoid writing the fully qualified name of the component class. Instead writing something like `render Views::Components::Forms::LabelComponent.new(for: "password")` you could write just `label_component(for: "password")`. You need to include the `Blueprint::HTML::ComponentRegistrar` module to make `register_component` macro available.

```crystal
class AlertComponent
  include Blueprint::HTML

  def initialize(@type : String); end

  private def blueprint(&)
    div class: "alert alert-#{@type}", role: "alert" do
      yield
    end
  end

  def title(&)
    h4(class: "alert-heading") { yield }
  end

  def body(&)
    p { yield }
  end
end

module ComponentHelpers
  include Blueprint::HTML::ComponentRegistrar

  register_component :alert_component, AlertComponent
end

class ExamplePage
  include Blueprint::HTML
  include ComponentHelpers

  private def blueprint
    h1 { "Hello" }
    alert_component(type: "primary") do |alert|
      alert.title { "My Alert" }
      alert.body { "Alert body" }
    end
  end
end
```

Output:
```html
<h1>Hello</h1>
<div class="alert alert-primary" role="alert">
  <h4 class="alert-heading">My alert</h4>
  <p>Alert body</p>
</div>
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
