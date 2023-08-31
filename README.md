<p align="center">
  <a href="https://stephannv.github.io/blueprint-docs/" target="_blank">
    <picture>
      <img
        alt="Blueprint logo"
        src="https://raw.githubusercontent.com/stephannv/blueprint/HEAD/.github/blueprint-logo.svg"
        width="200"
        height="200"
        style="max-width: 100%;"
      >
    </picture>
  </a>
</p>

<p align="center">
  A framework for writing reusable and testable HTML templates in plain Crystal.
</p>

<p align="center">
  <a href="https://github.com/stephannv/blueprint/actions/workflows/ci.yml"><img src="https://github.com/stephannv/blueprint/actions/workflows/ci.yml/badge.svg" alt="Tests & Code Format"></a>
  <a href="https://github.com/stephannv/blueprint/actions/workflows/weekly.yml"><img src="https://github.com/stephannv/blueprint/actions/workflows/weekly.yml/badge.svg" alt="Weekly CI"></a>
</p>

------

Example:
```crystal
class Alert
  include Blueprint::HTML

  private def blueprint
    div class: "alert alert-success" do
      h4(class: "alert-heading") { "Well done!" }
      p { "Hellow Word" }
    end
  end
end

Alert.new.to_html
```

Output:
```html
<div class="alert alert-success">
  <h4 class="alert-heading">Well done!</h4>
  <p>Hello World</p>
</div>
```

## Documentation

For full documentation, visit <https://stephannv.github.io/blueprint-docs/>.

## Contributing

1. Fork it (<https://github.com/stephannv/blueprint/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
