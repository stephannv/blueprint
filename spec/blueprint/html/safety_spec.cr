require "../../spec_helper"

private class DummyPage
  include Blueprint::HTML

  register_element :v_btn

  private def blueprint
    span { "<script>alert('hello')</script>" }
    span "<script>alert('content')</script>"
    plain "<script>alert('Plain Text')</script>"
    render(DummyComponent.new) { "<script>alert('DummyComponent')</script>" }
    div(class: "some-class\" onblur=\"alert('Attribute')")
    comment { "--><script>alert('Plain Text')</script><!--" }
    comment "--><script>alert('Another plain text')</script><!--"
    v_btn "<script>alert('content')</script>"
    v_btn(class: "some-class\" onclick=\"alert('Attribute')") { "<script>alert('hello')</script>" }
  end
end

private class DummyComponent
  include Blueprint::HTML

  private def blueprint(&)
    yield
  end
end

describe "Blueprint::HTML safety" do
  it "escapes content passed to tags via block" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <span>&lt;script&gt;alert(&#39;hello&#39;)&lt;/script&gt;</span>
    HTML

    page.to_html.should contain(expected_html)
  end

  it "escapes content passed to tags via argument" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <span>&lt;script&gt;alert(&#39;content&#39;)&lt;/script&gt;</span>
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

  it "escapes comment content passed via block" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <!----&gt;&lt;script&gt;alert(&#39;Plain Text&#39;)&lt;/script&gt;&lt;!---->
    HTML

    page.to_html.should contain(expected_html)
  end

  it "escapes comment content passed via argument" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <!----&gt;&lt;script&gt;alert(&#39;Another plain text&#39;)&lt;/script&gt;&lt;!---->
    HTML

    page.to_html.should contain(expected_html)
  end

  it "escapes custom tag content passed via argument" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <v-btn>&lt;script&gt;alert(&#39;content&#39;)&lt;/script&gt;</v-btn>
    HTML

    page.to_html.should contain(expected_html)
  end

  it "escapes custom tag content passed via block" do
    page = DummyPage.new
    expected_html = <<-HTML.strip
      <v-btn class="some-class&quot; onclick=&quot;alert(&#39;Attribute&#39;)">&lt;script&gt;alert(&#39;hello&#39;)&lt;/script&gt;</v-btn>
    HTML

    page.to_html.should contain(expected_html)
  end
end
