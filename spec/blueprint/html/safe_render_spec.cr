require "../../spec_helper"

describe "#safe" do
  it "returns an object that Blueprint will understand as safe to render without escaping" do
    actual_html = Blueprint::HTML.build do
      div(onclick: safe("<script>Attribute script</script>")) { safe("<script>Good Script</script>") }

      span { safe("<script>Another Good Script</script>") }
    end

    expected_html = normalize_html <<-HTML
      <div onclick="<script>Attribute script</script>">
        <script>Good Script</script>
      </div>

      <span>
        <script>Another Good Script</script>
      </span>
    HTML

    actual_html.should eq expected_html
  end
end
