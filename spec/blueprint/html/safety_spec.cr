require "../../spec_helper"

private class DummyPage
  include Blueprint::HTML

  def blueprint
    span { "<script>alert('hello')</script>" }
    plain "<script>alert('Plain Text')</script>"
    render(DummyComponent.new) { "<script>alert('DummyComponent')</script>" }
    div(class: "some-class\" onblur=\"alert('Attribute')")
  end
end

private class DummyComponent
  include Blueprint::HTML

  def blueprint(&)
    yield
  end
end

describe "Blueprint::HTML safety" do
  it "escapes content passed to tags" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <span>&lt;script&gt;alert(&#39;hello&#39;)&lt;/script&gt;</span>
    HTML

    page.to_html.should contain(expected_html)
  end

  it "escapes plain text" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      &lt;script&gt;alert(&#39;Plain Text&#39;)&lt;/script&gt;
    HTML

    page.to_html.should contain(expected_html)
  end

  it "escapes content passed to blueprints" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      &lt;script&gt;alert(&#39;DummyComponent&#39;)&lt;/script&gt;
    HTML

    page.to_html.should contain(expected_html)
  end

  it "escapes attribute values" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <div class="some-class&quot; onblur=&quot;alert(&#39;Attribute&#39;)"></div>
    HTML

    page.to_html.should contain(expected_html)
  end
end
