require "../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  private def blueprint
    render BaseLayout.new do
      header do
        h1 { "Test page" }
        h4 { "Page description" }
        button(disabled: true) { "Disabled button" }
        button(disabled: false) { "Enabled button" }
      end

      div class: "bg-gray-200" do
        p(data: {id: 54, highlight: "true"}) { "Page text" }

        plain "Plain text"

        iframe src: "example.com"

        render CardComponent.new do |c|
          c.body { "Card body" }
          c.footer do
            a(href: "/about", aria: {selected: "false", posinset: 3}) { "About" }
          end
          footer do
            card_footer_text
          end
        end
      end

      render FooterComponent.new
    end
  end

  private def card_footer_text
    "Card footer text"
  end
end

private class BaseLayout
  include Blueprint::HTML

  def blueprint(&)
    doctype

    html lang: "en" do
      head do
        title { "Test page" }

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

private class FooterComponent
  include Blueprint::HTML

  def blueprint
    footer do
      label(for: "email", v_model: "user.email", "@input": "doSomething") { "Email" }
      input type: "text", id: "email"
      span { "Footer" }
    end
  end
end

private class CardComponent
  include Blueprint::HTML

  def blueprint(&)
    div class: "flex flex-col gap-2 bg-white border shadow" do
      yield
    end
  end

  def body(&)
    div class: "p-4" do
      yield
    end
  end

  def footer(&)
    div class: "px-4 py-2" do
      yield
    end
  end
end

describe Blueprint::HTML do
  describe "#to_html" do
    it "renders html" do
      page = ExamplePage.new
      expected_html = <<-HTML.strip.gsub(/\n\s+/, "")
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
            <header>
              <h1>Test page</h1>
              <h4>Page description</h4>
              <button disabled>Disabled button</button>
              <button>Enabled button</button>
            </header>

            <div class="bg-gray-200">
              <p data-id="54" data-highlight="true">Page text</p>

              Plain text

              <iframe src="example.com"></iframe>

              <div class="flex flex-col gap-2 bg-white border shadow">

                <div class="p-4">
                  Card body
                </div>

                <div class="px-4 py-2">
                  <a href="/about" aria-selected="false" aria-posinset="3">About</a>
                </div>

                <footer>
                  Card footer text
                </footer>
              </div>
            </div>

            <footer>
              <label for="email" v-model="user.email" @input="doSomething">Email</label>
              <input type="text" id="email">
              <span>Footer</span>
            </footer>
          </body>
        </html>
      HTML

      html = page.to_html

      html.should eq expected_html
    end
  end
end
