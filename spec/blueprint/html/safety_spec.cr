require "../../spec_helper"

private class Example
  include Blueprint::HTML

  register_element :v_btn

  private def blueprint(&)
    yield
  end
end

describe "safety" do
  it "escapes tag content" do
    actual_html = Blueprint::HTML.build do
      span { "<script>alert('hello')</script>" }
    end

    expected_html = normalize_html <<-HTML
      <span>&lt;script&gt;alert(&#39;hello&#39;)&lt;/script&gt;</span>
    HTML

    actual_html.should eq expected_html
  end

  it "escapes plain text" do
    actual_html = Blueprint::HTML.build do
      plain "<script>alert('Plain Text')</script>"
    end

    expected_html = normalize_html <<-HTML
      &lt;script&gt;alert(&#39;Plain Text&#39;)&lt;/script&gt;
    HTML

    actual_html.should eq expected_html
  end

  it "escapes content passed to blueprints" do
    actual_html = Blueprint::HTML.build do
      render(Example.new) { "<script>alert('Example')</script>" }
    end

    expected_html = normalize_html <<-HTML
      &lt;script&gt;alert(&#39;Example&#39;)&lt;/script&gt;
    HTML

    actual_html.should eq expected_html
  end

  it "escapes attribute values" do
    actual_html = Blueprint::HTML.build do
      div(class: "some-class\" onblur=\"alert('Attribute')")
    end

    expected_html = normalize_html <<-HTML
      <div class="some-class&quot; onblur=&quot;alert('Attribute')"></div>
    HTML

    actual_html.should eq expected_html
  end

  it "escapes comment content" do
    actual_html = Blueprint::HTML.build do
      comment "--><script>alert('Comment')</script><!--"
    end

    expected_html = normalize_html <<-HTML
      <!----&gt;&lt;script&gt;alert(&#39;Comment&#39;)&lt;/script&gt;&lt;!---->
    HTML

    actual_html.should eq expected_html
  end

  it "escapes custom tag content" do
    actual_html = Example.new.to_s do |example|
      example.v_btn(class: "some-class\" onclick=\"alert('Attribute')") { "<script>alert('hello')</script>" }
    end

    expected_html = normalize_html <<-HTML
      <v-btn class="some-class&quot; onclick=&quot;alert('Attribute')">&lt;script&gt;alert(&#39;hello&#39;)&lt;/script&gt;</v-btn>
    HTML

    actual_html.should eq expected_html
  end

  it "escapes element content" do
    actual_html = Blueprint::HTML.build do
      element("my-card", class: "some-class\" onblur=\"alert('Attribute')") { "<script>alert('Example')</script>" }
    end

    expected_html = normalize_html <<-HTML
      <my-card class="some-class&quot; onblur=&quot;alert('Attribute')">
        &lt;script&gt;alert(&#39;Example&#39;)&lt;/script&gt;
      </my-card>
    HTML

    actual_html.should eq expected_html
  end
end
