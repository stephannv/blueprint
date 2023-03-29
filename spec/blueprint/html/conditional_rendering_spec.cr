require "../../spec_helper"

private class DummyPage
  include Blueprint::HTML

  def blueprint
    div do
      render(NoRenderComponent.new)
      render(NoRenderComponent.new) { "This component will not be rendered" }
    end
  end
end

private class NoRenderPage
  include Blueprint::HTML

  def blueprint
    h1 { "This page will not be rendered" }
  end

  def blueprint(&)
    h1 { yield }
  end

  def render?
    false
  end
end

private class NoRenderComponent
  include Blueprint::HTML

  def blueprint
    h1 { "This component will not be rendered" }
  end

  def blueprint(&)
    h1 { yield }
  end

  def render?
    false
  end
end

describe "Blueprint::HTML conditional rendering" do
  context "when component `#render?` returns false" do
    it "doesn't render the component" do
      page = DummyPage.new
      expected_html = <<-HTML.strip
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
