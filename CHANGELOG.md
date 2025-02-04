# Changelog

All notable changes to this project will be documented here. The updated docs can be found on <https://stephannv.github.io/blueprint-docs/>.

# [1.0.0] - 2025-01-25

### New versioning strategy
Blueprint don't follow semantic versioning (SemVer). Instead, it will follow something like [BreakVer](https://www.taoensso.com/break-versioning) or [PrideVer](https://pridever.org/).
- Major: Big changes and/or big features
- Minor: Small changes that can break old code but the effort to fix it is minimal
- Patch: Non-breaking changes

### Performance Improvement
Blueprint::HTML 0.11.0
```
Blueprint::HTML 0.11.0 755.39k (  1.32µs) (± 0.80%)  2.69kB/op   6.75× slower
                   ECR   5.10M (196.14ns) (± 0.51%)  1.51kB/op        fastest
```

Blueprint::HTML 1.0.0
```
Blueprint::HTML 0.11.0 934.07k (  1.07µs) (± 0.51%)  2.69kB/op   5.45× slower
                   ECR   5.09M (196.31ns) (± 0.37%)  1.51kB/op        fastest
```

### `#render` accepts new argument types
Now it's possible to render many types with `render`:
```crystal
# Blueprint classes
render Card # same as `render Card.new`

# Procs
render -> { 1 + 2 }

# Strings
render "hello"

# Any object that responds to_s
render MyObject.new
```

## Breaking changes!
### Rename `#envelope` to `#around_render`
The `#envelope` method was renamed to `#around_render`:
Old:
```crystal
class Layout
  include Blueprint::HTML

  def envelope(&)
    html do
      body { yield }
    end
  end
end
```

New:
```crystal
class Layout
  include Blueprint::HTML

  def around_render(&)
    html do
      body { yield }
    end
  end
end
```

### Restrict `#plain` argument type
Before you could pass anything to `#plain`, now it accepts only `String`. You
can use `#render` to render other type of objects.

```crystal
# before
plain some_object

# now
render some_object
```

### Remove capability to pass element content via argument.
Before you could write:
```crystal
h1 "Hello"
# Or
h1 { "Hello" }
```
Now the content are passed only via block:
```crystal
h1 { "Hello" }
```

### Remove Form builder
Form builder was removed from Blueprint core. It's possible that will become a
separate shard. You are using form builder, you extract the code from
[here](https://github.com/stephannv/blueprint/pull/94/files).

### Remove Style variants
Style variants was removed from Blueprint core. It's possible that will become a
separate shard. You are using style variants, you extract the code from
[here](https://github.com/stephannv/blueprint/pull/94/files).

### Remove component registrar
The `register_component` macro was removed from Blueprint core. If you are
using this macro, you extract the code from
[here](https://github.com/stephannv/blueprint/pull/97/files)

### Remove `#tokens`
The `#tokens` method was removed. You can replace it with plain Crystal:
```crystal
# with #tokens method
div class: tokens("x", admin?: "is-admin")

# with plain crystal
div class: ["x", ("is-admin" if admin?)]
```

If you need, yout can get the `#tokens` code from
[here](https://github.com/stephannv/blueprint/pull/87/files).

# [0.11.0] - 2024-10-11

### Add `escape_once` helper

It escapes HTML without affecting existing escaped entities
```crystal
class ExamplePage
  include Blueprint::HTML

  def blueprint
    plain escape_once("1 < 2 &amp; 3")

    span escape_once("&lt;&lt; Accept & Checkout")

    span { escape_once("<script>alert('content')</script>") }
  end
end

puts ExamplePage.new.to_s
```

Output:
```html
1 &lt; 2 &amp; 3

<span>&lt;&lt; Accept &amp; Checkout</span>

<span>&lt;script&gt;alert(&#39;content&#39;)&lt;/script&gt;</span>
```

### Change attribute value escaper
Before attribute values were escaped using `HTML.escape`, now the escape is done using `.gsub('"', "&quot;")`.

```crystal
class ExamplePage
  include Blueprint::HTML

  def blueprint
    input(value: %(>'test'<">))
    # Before <input value="&gt;&#39;test&#39;&lt;&quot;&gt;">
    # After <input value=">'test'<&quot;>">
  end
end
```

# [0.10.0] - 2024-10-11

### Allow any type `#plain`/`#comment` methods

Now you can pass any object that responds `to_s` to `#plain`/`#comment` methods.

```crystal
class ExamplePage
  include Blueprint::HTML

  def blueprint
    # before:
    plain custom_object.to_s
    comment other_object.to_s

    # after:
    plain custom_object
    comment other_object
  end
end
```

# [0.9.0] - 2024-09-21

### Form Builder
Using `#form_builder` you can access some utility methods to build labels and inputs:

```crystal
class ExamplePage
  include Blueprint::HTML

  def blueprint
    form_builder action: "/sign-in", method: :post do |form|
      form.label :email
      form.email_input :email

      form.label :password
      form.password_input :password
    end
  end
end

puts ExamplePage.new.to_s
# <form action="/sign-in" method="post">
#   <label for="email">Email</label>
#   <input type="email" id="email" name="email">
#
#   <label for="password">Password</label>
#   <input type="password" id="password" name="password">
# </form>
```

More example at docs: https://stephannv.github.io/blueprint-docs/handbook/forms/


# [0.8.0] - 2024-09-14

### Overhauled docs
The [Blueprint Docs](https://stephannv.github.io/blueprint-docs/) was revised.

### Style Variants (Experimental)
Defining a schema for variants within the component class to compile the final list of CSS classes.

```crystal
class AlertComponent
  include Blueprint::HTML

  style_builder do
    base "alert"

    variants do
      type {
        info "alert-info"
        danger "alert-danger"
      }

      size {
        xs "text-xs p-2"
        md "text-md p-4"
        lg "text-lg p-6"
      }

      closable {
        yes "alert-closable"
      }

      special {
        yes "alert-special"
        no "alert-default"
      }
    end

    defaults type: :info, size: :md
  end

  def blueprint
    div(class: build_style(type: :danger, size: :lg, closable: true)) do
      "My styled alert component"
    end
  end
end

puts AlertComponent.build_style(type: :info, size: :xs, special: false)
# "alert alert-info text-xs p-2 alert-default"

puts AlertComponent.new.to_s
# <div class="alert alert-danger text-lg p-6 alert-closable">
#  My styled alert component
# </div>
```

### Tokens (Experimental)
Allows to build classes based on conditionals.

```crystal
class UserComponent
  include Blueprint::HTML

  def blueprint
    h1 class: tokens(admin?: "is-admin", moderator?: "is-moderator") do
      "Jane Doe"
    end
  end

  def admin?
    false
  end

  def moderator?
    true
  end
end

puts UserComponent.new.to_s

# <h1 class="is-moderator">
#   Jane Doe
# </h1>
```

### Add `#safe` helper
The `#safe` method wraps the given object in a `Blueprint::SafeValue`, indicating
to Blueprint that the content should be rendered without escaping.

### BREAKING: Change `#to_html` to `#to_s`
Instead of `MyComponent.new.to_html` you should use `MyComponent.new.to_s`.

### BREAKING: Remove some utils methods
The methods `#plain(&)` and `#comment(&)` were removed, but you still can use
the `#plain(content : String)` and `#comment(content : String)`.

### BREAKING: Remove `#unsafe_raw`
`#unsafe_raw` was removed in favor of `#raw`.
```crystal
# BEFORE
unsafe_raw "<script>My Script</script>"

# AFTER
raw safe("<script>My Script</script>")
```

### BREAKING: Remove `Blueprint::RawHTML`
The `Blueprint::RawHTML` included in 0.7.0 was removed. A module focused on performance will be planned in the future.

### Include Blueprint::HTML::ComponenentRegistrar by default
You don't need to require and include `Blueprint::HTML::ComponenentRegistrar`, it
is already included when you include `Blueprint::HTML`.


# [0.7.0] - 2024-09-09

### Allow passing comment via argument

```crystal
comment "Cool comment here"
```

### Allow rendering unsafe content using `unsafe_raw`

```crystal
unsafe_raw "<script>alert('Danger!')</script>"
```


### RawHTML

Add `RawHtml` to priorize performance over safety
```crystal
require "blueprint/unsafe_html"
class MyHTML
  include Blueprint::UnsafeHTML

  def blueprint
    div "<script>alert('Danger!')</script>" # this will not be escaped
  end
end
```

### Code refactoring
Code refactoring to improve performance

### Fix escaping
Fix safety when passing content to elements via argument


# [0.6.0] - 2024-09-08

### Passing content via argument

Allows passing content to elements without using blocks, eg.

```crystal
  h1 { "Hello World!" }
  # or
  h1 "Hello World!"
```

# [0.5.1] - 2024-09-08

Fix Crystal version string requirement allowing using Blueprint with newer crystal versions.

# [0.5.0] - 2024-09-08

### Performance improvements

Increased speed execution by 15%.

```
v0.5.0 364.46k (  2.74µs) (± 0.52%)  7.95kB/op  fastest
v0.4.0 317.83k (  3.15µs) (± 0.76%)  8.99kB/op  1.15× slower
```

### Fix Array attributes

Ignore nil elements from array attribute parsing

```crystal
class Example
  include Blueprint::HTML

  private def blueprint
    h1(class: ["a", "b", nil, ["c", "d"]]) { "Example" }
  end
end

example = Example.new
example.to_html # => "<h1 class="a b c d">Example</h1>"
```


# [0.4.0] - 2023-04-25

### SVG support

It's possible to create SVG elements:

```crystal
class Example
  include Blueprint::HTML

  private def blueprint
    svg width: 30, height: 10 do
      g fill: :red do
        rect x: 0, y: 0, width: 10, height: 10
        rect x: 20, y: 0, width: 10, height: 10
      end
    end
  end
end
```

Output:
```html
<svg width="30" height="10">
  <g fill="red">
    <rect x="0" y="0" width="10" height="10"></rect>
    <rect x="20" y="0" width="10" height="10"></rect>
  </g>
</svg>
```


# [0.3.0] - 2023-04-07

### Build HTML without defining classes or structs

It's possible build HTML without using classes or structs

```crystal
html = Blueprint::HTML.build do
  h1 { "Hello" }
  div do
    h2 { "World" }
  end
end

puts html # => <h1>Hello</h1><div><h2>World</h2></div>
```


# [0.2.0] - 2023-04-07

### Allow conditional rendering

It's possible to override `#render?` method to control blueprint render.

```crystal
class Example
  include Blueprint::HTML

  private def blueprint
    h1 { "Example" }
  end

  private def render?
    false
  end
end

example = Example.new
example.to_html # => ""
```

### Handles array attributes

Arrays passed as attribute values will be flattened and joined with `" "`.

```crystal
class Example
  include Blueprint::HTML

  private def blueprint
    h1(class: ["a", "b", ["c", "d"]]) { "Example" }
  end
end

example = Example.new
example.to_html # => "<h1 class="a b c d">Example</h1>"
```

### Adds `#envelope(&)` method

By overriding the `#envelope(&)` method, you can create a wrapper around
blueprint content. This is useful when defining layouts for pages.

```crystal
class Example
  include Blueprint::HTML

  private def blueprint
    h1 { "Example" }
  end

  private def envelope(&)
    html do
      body do
        yield
      end
    end
  end
end

example = Example.new
example.to_html # => "<html><body><h1>Hello</h1></body></html>"
```

### Breaking changes
- Requires `require "blueprint/html"` instead `require "blueprint"` to use `Blueprint::HTML` module



# [0.1.0] - 2023-03-27

### Added
- Basic html builder
- Allow element attributes
- Allow rendering blueprints
- Allow NamedTuple attributes
- Add `doctype` util
- Transform attribute names
- Handle boolean attributes
- Escape content
- Add `comment` util
- Add `whitespace` util
- Allow custom component registration
- Allow custom element registration
