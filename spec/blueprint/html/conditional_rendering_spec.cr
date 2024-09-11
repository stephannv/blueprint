require "../../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  private def blueprint
    div do
      render(NoRenderComponent.new)
      render(NoRenderComponent.new) { "This component will not be rendered" }
    end
  end
end

private class NoRenderPage
  include Blueprint::HTML

  private def blueprint
    h1 "This page will not be rendered"
  end

  private def blueprint(&)
    h1 { yield }
  end

  def render?
    false
  end
end

private class NoRenderComponent
  include Blueprint::HTML

  private def blueprint
    h1 "This component will not be rendered"
  end

  private def blueprint(&)
    h1 { yield }
  end

  def render?
    false
  end
end

describe "conditional rendering" do
  context "when component `#render?` returns false" do
    it "doesn't render the component" do
      page = ExamplePage.new
      expected_html = normalize_html <<-HTML
        <div></div>
      HTML

      page.to_html.should eq expected_html
    end
  end

  context "when blueprint `#render?` returns false" do
    it "doesn't render the blueprint" do
      page = NoRenderPage.new
      page.to_html.should eq ""

      page = NoRenderPage.new
      html = page.to_html { "This page will not be rendered" }
      html.should eq ""
    end
  end
end
