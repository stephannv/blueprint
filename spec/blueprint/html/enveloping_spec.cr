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

private class IndexPage < BasePage
  private def blueprint
    h1 "Home"
  end
end

describe "Blueprint::HTML enveloping" do
  it "allows defining a blueprint wrapper" do
    page = IndexPage.new

    page.to_html.should eq "<html><body><h1>Home</h1></body></html>"
  end
end
