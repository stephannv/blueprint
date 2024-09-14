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
end
