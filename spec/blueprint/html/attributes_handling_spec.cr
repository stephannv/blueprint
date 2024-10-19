require "../../spec_helper"

describe "attributes handling" do
  it "parses normal attributes" do
    actual_html = Blueprint::HTML.build do
      div "Blueprint", class: "hello", id: "first"
    end

    expected_html = normalize_html <<-HTML
      <div class="hello" id="first">Blueprint</div>
    HTML

    actual_html.to_s.should eq expected_html
  end

  it "converts attribute values to string" do
    actual_html = Blueprint::HTML.build do
      span id: 421, float: 2.4, md: MarkdownLink.new("Example", "example.com") do
        "Blueprint"
      end
    end

    expected_html = normalize_html <<-HTML
      <span id="421" float="2.4" md="[Example](example.com)">Blueprint</span>
    HTML

    actual_html.to_s.should eq expected_html
  end

  it "replaces `_` by `-` on attribute names" do
    actual_html = Blueprint::HTML.build do
      section "Blueprint", v_model: "user.name", "@click": "doSomething"
    end

    expected_html = normalize_html <<-HTML
      <section v-model="user.name" @click="doSomething">Blueprint</section>
    HTML

    actual_html.to_s.should eq expected_html
  end

  it "accepts boolean attributes" do
    actual_html = Blueprint::HTML.build do
      input disabled: true, checked: false, outline: "true", border: "false"
    end

    expected_html = normalize_html <<-HTML
      <input disabled outline="true" border="false">
    HTML

    actual_html.to_s.should eq expected_html
  end

  it "expands NamedTuple attributes" do
    actual_html = Blueprint::HTML.build do
      nav "Blueprint", aria: {target: "#home", selected: "false", enabled: true, hidden: false}
    end

    expected_html = normalize_html <<-HTML
      <nav aria-target="#home" aria-selected="false" aria-enabled>Blueprint</nav>
    HTML

    actual_html.to_s.should eq expected_html
  end

  it "flattens, compacts and joins array attributes" do
    actual_html = Blueprint::HTML.build do
      div "Blueprint", class: ["a", nil, "b", ["c", nil, "d"]]
    end

    expected_html = normalize_html <<-HTML
      <div class="a b c d">Blueprint</div>
    HTML

    actual_html.to_s.should eq expected_html
  end
end
