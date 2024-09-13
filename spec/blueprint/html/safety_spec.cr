require "../../spec_helper"

private class Example
  include Blueprint::HTML

  register_element :v_btn

  private def blueprint
    span { "<script>alert('hello')</script>" }
    span "<script>alert('content')</script>"
    plain "<script>alert('Plain Text')</script>"
    render(ExampleComponent.new) { "<script>alert('ExampleComponent')</script>" }
    div(class: "some-class\" onblur=\"alert('Attribute')")
    comment "--><script>alert('Comment')</script><!--"
    v_btn "<script>alert('content')</script>"
    v_btn(class: "some-class\" onclick=\"alert('Attribute')") { "<script>alert('hello')</script>" }
  end
end

private class ExampleComponent
  include Blueprint::HTML

  private def blueprint(&)
    yield
  end
end

describe "safety" do
  it "escapes content passed to tags via block" do
    page = Example.new
    expected_html = normalize_html <<-HTML
      <span>&lt;script&gt;alert(&#39;hello&#39;)&lt;/script&gt;</span>
    HTML

    page.to_s.should contain(expected_html)
  end

  it "escapes content passed to tags via argument" do
    page = Example.new
    expected_html = normalize_html <<-HTML
      <span>&lt;script&gt;alert(&#39;content&#39;)&lt;/script&gt;</span>
    HTML

    page.to_s.should contain(expected_html)
  end

  it "escapes plain text" do
    page = Example.new
    expected_html = normalize_html <<-HTML
      &lt;script&gt;alert(&#39;Plain Text&#39;)&lt;/script&gt;
    HTML

    page.to_s.should contain(expected_html)
  end

  it "escapes content passed to blueprints" do
    page = Example.new
    expected_html = normalize_html <<-HTML
      &lt;script&gt;alert(&#39;ExampleComponent&#39;)&lt;/script&gt;
    HTML

    page.to_s.should contain(expected_html)
  end

  it "escapes attribute values" do
    page = Example.new
    expected_html = normalize_html <<-HTML
      <div class="some-class&quot; onblur=&quot;alert(&#39;Attribute&#39;)"></div>
    HTML

    page.to_s.should contain(expected_html)
  end

  it "escapes comment content" do
    page = Example.new
    expected_html = normalize_html <<-HTML
      <!----&gt;&lt;script&gt;alert(&#39;Comment&#39;)&lt;/script&gt;&lt;!---->
    HTML

    page.to_s.should contain(expected_html)
  end

  it "escapes custom tag content passed via argument" do
    page = Example.new
    expected_html = normalize_html <<-HTML
      <v-btn>&lt;script&gt;alert(&#39;content&#39;)&lt;/script&gt;</v-btn>
    HTML

    page.to_s.should contain(expected_html)
  end

  it "escapes custom tag content passed via block" do
    page = Example.new
    expected_html = normalize_html <<-HTML
      <v-btn class="some-class&quot; onclick=&quot;alert(&#39;Attribute&#39;)">&lt;script&gt;alert(&#39;hello&#39;)&lt;/script&gt;</v-btn>
    HTML

    page.to_s.should contain(expected_html)
  end
end
