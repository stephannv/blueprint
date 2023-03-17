require "../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  private def blueprint
    html do
      head do
        title { "Test page" }

        meta charset: "utf-8"

        link href: "app.css", rel: "stylesheet"
        script type: "text/javascript", src: "app.js"
      end

      body do
        header do
          h1 { "Test page" }
          h4 { "Page description" }
        end

        div class: "bg-gray-200" do
          p { "Page text" }

          plain "Plain text"

          iframe src: "example.com"
        end

        footer do
          label(for: "email") { "Email" }
          input type: "text", id: "email"
          span { "Footer" }
        end
      end
    end
  end
end

describe Blueprint::HTML do
  describe "#call" do
    it "renders page" do
      page = render ExamplePage.new
      expected_html = %(
        <html>
          <head>
            <title>Test page</title>

            <meta charset="utf-8">

            <link href="app.css" rel="stylesheet">
            <script type="text/javascript" src="app.js"></script>
          </head>

          <body>
            <header>
              <h1>Test page</h1>
              <h4>Page description</h4>
            </header>

            <div class="bg-gray-200">
              <p>Page text</p>

              Plain text

              <iframe src="example.com"></iframe>
            </div>

            <footer>
              <label for="email">Email</label>
              <input type="text" id="email">
              <span>Footer</span>
            </footer>
          </body>
        </html>
      ).gsub(/\n\s+/, "")

      page.should eq expected_html
    end
  end
end
