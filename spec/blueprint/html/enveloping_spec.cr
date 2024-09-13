private class MainLayout
  include Blueprint::HTML

  private def blueprint(&)
    html do
      body do
        yield
      end
    end
  end
end

private class BasePage
  include Blueprint::HTML

  private def envelope(&)
    render(MainLayout.new) do
      yield
    end
  end
end

private class Component
  include Blueprint::HTML

  def blueprint
    h1 "Hello World!"
  end

  def envelope(&)
    div class: "title" do
      yield
    end
  end
end

private class IndexPage < BasePage
  private def blueprint
    h1 "Home"
    render Component.new
  end
end

describe "enveloping" do
  it "allows defining a blueprint wrapper" do
    page = IndexPage.new
    expected_html = normalize_html <<-HTML
      <html>
        <body>
          <h1>Home</h1>

          <div class="title">
            <h1>Hello World!</h1>
          </div>
        </body>
      </html>
    HTML

    page.to_s.should eq expected_html
  end
end
