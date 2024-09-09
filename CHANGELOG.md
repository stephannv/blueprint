# Changelog

All notable changes to this project will be documented on <https://stephannv.github.io/blueprint-docs/>.

## [0.7.0] - 2023-09-09

- Allow passing comment via argument
```crystal
comment "Cool comment here"
```

- Allow rendering unsafe content using `unsafe_raw`
```crystal
unsafe_raw "<script>alert('Danger!')</script>"
```

- Add `RawHtml` to priorize performance over safety
```crystal
require "blueprint/unsafe_html"
class MyHTML
  include Blueprint::UnsafeHTML

  def blueprint
    div "<script>alert('Danger!')</script>" # this will not be escaped
  end
end
```

- Code refactoring to improve performance
- Fix safety when passing content to elements via argument


## [0.6.0] - 2023-09-08

Allows passing content to elements without using blocks, eg.

```crystal
  h1 { "Hello World!" }
  # or
  h1 "Hello World!"
```

Release details: <https://stephannv.github.io/blueprint-docs/changelogs/v0.6.0/>

## [0.5.1] - 2023-09-08

Fix Crystal version string requirement.

Release details: <https://stephannv.github.io/blueprint-docs/changelogs/v0.5.1/>

## [0.5.0] - 2023-09-08

Performance improvements: Increased speed execution by 15%.
```


v0.5.0 364.46k (  2.74µs) (± 0.52%)  7.95kB/op  fastest
v0.4.0 317.83k (  3.15µs) (± 0.76%)  8.99kB/op  1.15× slower

```

Release details: <https://stephannv.github.io/blueprint-docs/changelogs/v0.5.0/>

## [0.4.0] - 2023-04-25

Release details: <https://stephannv.github.io/blueprint-docs/changelogs/v0.4.0/>

## [0.3.0] - 2023-04-07

Release details: <https://stephannv.github.io/blueprint-docs/changelogs/v0.3.0/>

## [0.2.0] - 2023-04-07

Release details: <https://stephannv.github.io/blueprint-docs/changelogs/v0.2.0/>

## [0.1.0] - 2023-03-27

Release details: <https://stephannv.github.io/blueprint-docs/changelogs/v0.1.0/>
