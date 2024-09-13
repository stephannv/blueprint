require "../spec_helper"

private class BaseLayout
  include Blueprint::HTML

  private def blueprint(&)
    doctype

    html lang: "en" do
      head do
        title "Test page"

        meta charset: "utf-8"
        meta name: "viewport", content: "width=device-width,initial-scale=1"

        link href: "app.css", rel: "stylesheet"
        script type: "text/javascript", src: "app.js"
      end

      body do
        yield
      end
    end
  end
end

private class NavbarComponent
  include Blueprint::HTML

  private def blueprint
    nav do
      ul do
        li { a("Home", href: "/home") }
        li { a("About", href: "/about") }
        li { a("Contact", href: "/contact") }
      end
    end
  end
end

private class ArticleComponent
  include Blueprint::HTML

  def initialize(@title : String); end

  private def blueprint(&)
    div class: "flex flex-col gap-2 bg-white border shadow" do
      title
      yield
    end
  end

  def title
    div @title, class: "p-2 text-lg font-bold"
  end

  def body(&)
    div class: "p-4" do
      yield
    end
  end
end

private class ExamplePage
  include Blueprint::HTML

  private def blueprint
    render BaseLayout.new do
      render NavbarComponent.new

      div do
        article("Hello World", "Welcome to blueprint")
        article("Blueprint", "Blueprint is an Html builder")
      end
    end
  end

  private def article(title : String, content : String)
    render ArticleComponent.new(title) do |article|
      article.body { content }
    end
  end
end

describe Blueprint::HTML do
  describe "#to_s" do
    it "renders html" do
      page = ExamplePage.new
      expected_html = normalize_html <<-HTML
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <title>Test page</title>

            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width,initial-scale=1">

            <link href="app.css" rel="stylesheet">
            <script type="text/javascript" src="app.js"></script>
          </head>

          <body>
            <nav>
              <ul>
                <li><a href="/home">Home</a></li>
                <li><a href="/about">About</a></li>
                <li><a href="/contact">Contact</a></li>
              </ul>
            </nav>

            <div>
              <div class="flex flex-col gap-2 bg-white border shadow">
                <div class="p-2 text-lg font-bold">Hello World</div>
                <div class="p-4">Welcome to blueprint</div>
              </div>

              <div class="flex flex-col gap-2 bg-white border shadow">
                <div class="p-2 text-lg font-bold">Blueprint</div>
                <div class="p-4">Blueprint is an Html builder</div>
              </div>
            </div>
          </body>
        </html>
      HTML

      html = page.to_s

      html.should eq expected_html
    end
  end
end
