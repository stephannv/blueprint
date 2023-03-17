require "../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  private def blueprint
    html do
      head do
        title { "Test page" }
      end

      body do
        header do
          h1 { "Test page" }
          h4 { "Page description" }
        end

        div do
          p { "Page text" }

          plain "Plain text"
        end

        footer do
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
          </head>

          <body>
            <header>
              <h1>Test page</h1>
              <h4>Page description</h4>
            </header>

            <div>
              <p>Page text</p>

              Plain text
            </div>

            <footer>
              <span>Footer</span>
            </footer>
          </body>
        </html>
      ).gsub(/\n\s+/, "")

      page.should eq expected_html
    end
  end
end
