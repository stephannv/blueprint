# Blueprint

Blueprint is a framework for writing reusable and testable HTML templates in 
plain Crystal, allowing an oriented object approach when building web views.

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

## Getting Started
Check out the docs website: <https://blueprint.gunbolt.org>

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
