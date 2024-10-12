require "../../spec_helper"

private class ExamplePage
  include Blueprint::HTML

  private def blueprint
    div("Tokens", class: ["a", "b", tokens(c?: "c", d?: "d", e?: "e")])

    div(onclick: safe("<script>Attribute script</script>")) { safe("<script>Good Script</script>") }

    span safe("<script>Another Good Script</script>")
  end

  private def c?
    true
  end

  private def d?
    false
  end

  private def e?
    true
  end
end

describe "helpers" do
  describe "#tokens" do
    it "returns conditional classes" do
      page = ExamplePage.new
      expected_html = normalize_html <<-HTML
        <div class="a b c e">Tokens</div>
      HTML

      page.to_s.should contain expected_html
    end
  end

  describe "#safe" do
    it "returns an object that Blueprint will understand as safe to render without escaping" do
      page = ExamplePage.new
      expected_html = normalize_html <<-HTML
        <div onclick="<script>Attribute script</script>">
          <script>Good Script</script>
        </div>

        <span>
          <script>Another Good Script</script>
        </span>
      HTML

      page.to_s.should contain expected_html
    end
  end

  describe "#escape_once" do
    it "escapes HTML without affecting existing escaped entities" do
      actual_html = Blueprint::HTML.build do
        span escape_once("&lt;&lt; Accept & Checkout")

        div escape_once(MarkdownLink.new("1 < 2 &amp; 3", "example.com"))
      end

      expected_html = normalize_html <<-HTML
        <span>&lt;&lt; Accept &amp; Checkout</span>

        <div>[1 &lt; 2 &amp; 3](example.com)</div>
      HTML

      actual_html.to_s.should eq expected_html
    end

    it "escapes unsafe content" do
      actual_html = Blueprint::HTML.build do
        span escape_once("<script>alert('content')</script>")
      end

      expected_html = normalize_html <<-HTML
        <span>&lt;script&gt;alert(&#39;content&#39;)&lt;/script&gt;</span>
      HTML

      actual_html.to_s.should eq expected_html
    end
  end
end
